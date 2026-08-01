#!/usr/bin/env bash
# Acceptance test for the pgpm projections examples.
#
# For every committed module variant:
#   1. deploy it into its own scratch database (pgpm deploy)
#   2. run its verify scripts (pgpm verify)
# Then:
#   3. assert catalog equivalence across all granularity/partition variants
#      (same schema, different shapes -> identical catalog)
#   4. deploy shop@v1 + the generated shop-v1-to-v2 migration and assert the
#      resulting catalog equals examples/diff-migration/input/shop.v2.sql loaded fresh
#   5. revert every module and assert the database is left clean
#
# Steps whose packages don't exist yet are skipped with a notice, so CI stays
# green while the pipeline artifacts land incrementally.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

PSQL="psql -X -v ON_ERROR_STOP=1 -U ${PGUSER:-postgres} -h ${PGHOST:-localhost} -p ${PGPORT:-5432}"

note()  { echo "==> $*"; }
skip()  { echo "SKIP: $* (not generated yet)"; }

# Normalized schema-only catalog dump (comments/SET noise stripped, pgpm's
# own migrate ledger excluded) so structurally identical databases diff empty.
# Override with e.g. PG_DUMP="docker exec postgres pg_dump -U postgres" when
# the local pg_dump major version doesn't match the server.
PG_DUMP="${PG_DUMP:-pg_dump}"

catalog_dump() {
  local db="$1" out="$2" raw
  raw="$(mktemp)"
  $PG_DUMP --schema-only --no-owner --exclude-schema 'pgpm*' "$db" > "$raw"
  grep -vE '^(--|SET |SELECT pg_catalog\.set_config|\\)' "$raw" \
    | grep -v '^[[:space:]]*$' \
    | python3 -c '
# Column order is a physical artifact (ALTER-based migrations always
# append), so sort the body lines of each CREATE TABLE block.
import sys
body = None
for line in sys.stdin:
    line = line.rstrip("\n")
    if line.startswith("CREATE TABLE"):
        print(line); body = []
    elif body is not None and line.startswith(");"):
        for b in sorted(l.rstrip(",") for l in body):
            print(b)
        print(line); body = None
    elif body is not None:
        body.append(line)
    else:
        print(line)
' > "$out" || true
  rm -f "$raw"
  if [ ! -s "$out" ]; then
    echo "FAIL: catalog dump of $db produced no output"
    exit 1
  fi
}

module_name() {
  basename "$(ls "$1"/*.control)" .control
}

deploy_module() {
  local pkg_dir="$1" db="$2" pkg
  pkg="$(module_name "$pkg_dir")"
  note "deploy $pkg_dir -> $db"
  $PSQL -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname = '$db'" | grep -q 1 \
    || $PSQL -d postgres -c "CREATE DATABASE $db"
  (cd "$pkg_dir" && pgpm deploy --database "$db" --package "$pkg" --yes --no-tty)
  note "verify $pkg_dir on $db"
  (cd "$pkg_dir" && pgpm verify --database "$db" --package "$pkg" --no-tty)
}

revert_module() {
  local pkg_dir="$1" db="$2" pkg
  pkg="$(module_name "$pkg_dir")"
  note "revert $pkg_dir on $db"
  (cd "$pkg_dir" && pgpm revert --database "$db" --package "$pkg" --yes --no-tty)
}

# After every module on a database is reverted, no non-pgpm user schemas may remain.
assert_db_clean() {
  local db="$1"
  local leftovers
  leftovers=$($PSQL -d "$db" -tAc \
    "SELECT string_agg(nspname, ',') FROM pg_namespace
     WHERE nspname NOT LIKE 'pg_%'
       AND nspname NOT IN ('information_schema', 'public')
       AND nspname NOT LIKE 'pgpm%'")
  if [ -n "$leftovers" ]; then
    echo "FAIL: revert left schemas behind in $db: $leftovers"
    exit 1
  fi
  note "$db left clean after revert"
}

assert_same_catalog() {
  local db_a="$1" db_b="$2" label="$3"
  note "catalog compare: $db_a vs $db_b ($label)"
  local dump_a dump_b
  dump_a="$(mktemp)"; dump_b="$(mktemp)"
  catalog_dump "$db_a" "$dump_a"
  catalog_dump "$db_b" "$dump_b"
  if ! diff "$dump_a" "$dump_b"; then
    echo "FAIL: catalog mismatch between $db_a and $db_b ($label)"
    exit 1
  fi
  rm -f "$dump_a" "$dump_b"
  note "catalogs identical ($label)"
}

# ---------------------------------------------------------------------------
# 1+2. deploy + verify every variant into its own scratch database
# ---------------------------------------------------------------------------
declare -A VARIANT_DB=(
  [examples/import-dump/output/shop]=shop_object
  [examples/granularity-atomic/output/shop-atomic]=shop_atomic
  [examples/granularity-consolidated/output/shop-consolidated]=shop_consolidated
  [examples/naming-flat/output/shop-object]=shop_flat
  [examples/import-granularity/output/shop-atomic-direct]=shop_atomic_direct
  [examples/change-granularity-alteration/output/shop-per-alteration]=shop_per_alteration
  [examples/change-granularity-single/output/shop-single-change]=shop_single_change
  [examples/compose-projections/output/shop-composed]=shop_composed
)

DEPLOYED_VARIANTS=()
for pkg in "${!VARIANT_DB[@]}"; do
  if [ -d "$pkg" ]; then
    deploy_module "$pkg" "${VARIANT_DB[$pkg]}"
    DEPLOYED_VARIANTS+=("$pkg")
  else
    skip "$pkg"
  fi
done

# Partition pair deploys into ONE database (shop-security requires shop-app).
if [ -d examples/partition-security/output/shop-security ]; then
  deploy_module examples/partition-security/output/shop-app shop_partitioned
  deploy_module examples/partition-security/output/shop-security shop_partitioned
  DEPLOYED_PARTITION=1
else
  skip "examples/partition-security/output/shop-app + examples/partition-security/output/shop-security"
  DEPLOYED_PARTITION=0
fi

# ---------------------------------------------------------------------------
# 3. catalog equivalence across variants
# ---------------------------------------------------------------------------
if [ -d examples/import-dump/output/shop ]; then
  for pkg in "${DEPLOYED_VARIANTS[@]}"; do
    [ "$pkg" = examples/import-dump/output/shop ] && continue
    assert_same_catalog shop_object "${VARIANT_DB[$pkg]}" "object vs $(basename "$pkg")"
  done
  if [ "$DEPLOYED_PARTITION" = 1 ]; then
    assert_same_catalog shop_object shop_partitioned "object vs partitioned"
  fi
else
  skip "catalog equivalence (examples/import-dump/output/shop)"
fi

# ---------------------------------------------------------------------------
# 3b. the packed single-file projection of the module == the module
# ---------------------------------------------------------------------------
if [ -f examples/pack-module/output/shop.module.sql ] && [ -d examples/import-dump/output/shop ]; then
  note "load examples/pack-module/output/shop.module.sql fresh -> shop_packed"
  $PSQL -d postgres -c 'CREATE DATABASE shop_packed'
  $PSQL -d shop_packed -v ON_ERROR_STOP=1 -f examples/pack-module/output/shop.module.sql
  assert_same_catalog shop_object shop_packed "object vs packed single-file SQL"
else
  skip "packed single-file SQL check (examples/pack-module/output/shop.module.sql)"
fi

# ---------------------------------------------------------------------------
# 3b1b. the composed (all-projections) single-file output == the module
# ---------------------------------------------------------------------------
if [ -f examples/compose-projections/output/shop-composed.sql ] && [ -d examples/import-dump/output/shop ]; then
  note "load examples/compose-projections/output/shop-composed.sql fresh -> shop_composed_sql"
  $PSQL -d postgres -c 'CREATE DATABASE shop_composed_sql'
  $PSQL -d shop_composed_sql -v ON_ERROR_STOP=1 -f examples/compose-projections/output/shop-composed.sql
  assert_same_catalog shop_object shop_composed_sql "object vs composed single-file SQL"
else
  skip "composed single-file SQL check (examples/compose-projections/output/shop-composed.sql)"
fi

# ---------------------------------------------------------------------------
# 3b2. fast (bundle) deploy == normal change-by-change deploy
# ---------------------------------------------------------------------------
if [ -f examples/emit-bundle/output/shop.bundle.tar.gz ] && [ -d examples/import-dump/output/shop ]; then
  note "fast deploy examples/import-dump/output/shop -> shop_fast"
  $PSQL -d postgres -c 'CREATE DATABASE shop_fast'
  (cd examples/import-dump/output/shop && pgpm deploy --database shop_fast --package shop --fast --yes --no-tty)
  assert_same_catalog shop_object shop_fast "object vs fast (bundle) deploy"
else
  skip "fast (bundle) deploy check (examples/emit-bundle/output/shop.bundle.tar.gz)"
fi

# ---------------------------------------------------------------------------
# 3c. imported "statement soup" modules == their raw inputs loaded fresh
# ---------------------------------------------------------------------------
IMPORT_EQUIV_DEPLOYED=()
for spec in \
  "examples/fold-atomic-statements|blog|blog.atomic.sql" \
  "examples/flatten-history|inventory|inventory.churn.sql"; do
  IFS='|' read -r ex_dir pkg input <<< "$spec"
  if [ -d "$ex_dir/output/$pkg" ]; then
    deploy_module "$ex_dir/output/$pkg" "${pkg}_module"
    note "load $ex_dir/input/$input fresh -> ${pkg}_raw"
    $PSQL -d postgres -c "CREATE DATABASE ${pkg}_raw"
    $PSQL -d "${pkg}_raw" -v ON_ERROR_STOP=1 -f "$ex_dir/input/$input"
    assert_same_catalog "${pkg}_module" "${pkg}_raw" "$pkg module vs raw input"
    IMPORT_EQUIV_DEPLOYED+=("$ex_dir/output/$pkg|${pkg}_module")
  else
    skip "$ex_dir/output/$pkg"
  fi
done

# ---------------------------------------------------------------------------
# 4. shop@v1 + shop-v1-to-v2 migration == shop.v2.sql deployed fresh
# ---------------------------------------------------------------------------
if [ -d examples/diff-migration/output/shop-v1-to-v2 ] && [ -d examples/import-dump/output/shop ]; then
  deploy_module examples/import-dump/output/shop shop_migrated
  deploy_module examples/diff-migration/output/shop-v1-to-v2 shop_migrated

  note "load examples/diff-migration/input/shop.v2.sql fresh -> shop_v2_fresh"
  $PSQL -d postgres -c 'CREATE DATABASE shop_v2_fresh'
  $PSQL -d shop_v2_fresh -f examples/diff-migration/input/shop.v2.sql

  assert_same_catalog shop_migrated shop_v2_fresh "v1 + migration vs v2 fresh"

  # the same delta emitted per-alteration (diff --granularity/--change-granularity)
  if [ -d examples/diff-granularity/output/shop-v1-to-v2-per-alteration ]; then
    deploy_module examples/import-dump/output/shop shop_migrated_alt
    deploy_module examples/diff-granularity/output/shop-v1-to-v2-per-alteration shop_migrated_alt
    assert_same_catalog shop_migrated_alt shop_v2_fresh "v1 + per-alteration migration vs v2 fresh"
  else
    skip "per-alteration migration check (examples/diff-granularity/output/shop-v1-to-v2-per-alteration)"
  fi

  # the same delta as a content-addressed bundle artifact
  if [ -f examples/diff-bundle/output/shop.v1-to-v2.bundle.tar.gz ]; then
    note "inspect examples/diff-bundle/output/shop.v1-to-v2.bundle.tar.gz manifest"
    manifest=$(tar -xzOf examples/diff-bundle/output/shop.v1-to-v2.bundle.tar.gz pgpm-bundle.json)
    echo "$manifest" | grep -q '"name": "shop-v1-to-v2"'
    echo "$manifest" | grep -q '"changeCount": 7'
    note "diff bundle manifest OK (shop-v1-to-v2, 7 changes)"
  else
    skip "diff bundle check (examples/diff-bundle/output/shop.v1-to-v2.bundle.tar.gz)"
  fi

  # the --emit-sql projection of the same delta, applied as plain SQL
  if [ -f examples/diff-migration/output/shop.v1-to-v2.sql ]; then
    note "load v1 dump + linear delta SQL -> shop_sql_migrated"
    $PSQL -d postgres -c 'CREATE DATABASE shop_sql_migrated'
    $PSQL -d shop_sql_migrated -v ON_ERROR_STOP=1 -f examples/import-dump/input/shop.v1.sql
    $PSQL -d shop_sql_migrated -v ON_ERROR_STOP=1 -f examples/diff-migration/output/shop.v1-to-v2.sql
    assert_same_catalog shop_sql_migrated shop_v2_fresh "linear SQL delta vs v2 fresh"
  else
    skip "linear SQL delta check (examples/diff-migration/output/shop.v1-to-v2.sql)"
  fi
else
  skip "v1 -> v2 migration check (examples/diff-migration/output/shop-v1-to-v2)"
fi

# ---------------------------------------------------------------------------
# 4b. shop@v1 + shop-migrations (v1->v2 appended with v2->v3) == v3 fresh
# ---------------------------------------------------------------------------
if [ -d examples/append-migration/output/shop-migrations ] && [ -d examples/import-dump/output/shop ]; then
  deploy_module examples/import-dump/output/shop shop_v3_migrated
  deploy_module examples/append-migration/output/shop-migrations shop_v3_migrated

  note "load examples/append-migration/input/shop.v3.sql fresh -> shop_v3_fresh"
  $PSQL -d postgres -c 'CREATE DATABASE shop_v3_fresh'
  $PSQL -d shop_v3_fresh -v ON_ERROR_STOP=1 -f examples/append-migration/input/shop.v3.sql

  assert_same_catalog shop_v3_migrated shop_v3_fresh "v1 + appended migrations vs v3 fresh"
else
  skip "appended migration check (examples/append-migration/output/shop-migrations)"
fi

# ---------------------------------------------------------------------------
# 4b2. transform --check: the CLI's own lossless-transform oracle
# ---------------------------------------------------------------------------
if [ -d examples/import-dump/output/shop ]; then
  note "pgpm transform --check (consolidated) on examples/import-dump/output/shop"
  rm -rf /tmp/transform-check
  pgpm transform --granularity consolidated --check \
    --cwd examples/import-dump/output/shop --out /tmp/transform-check --no-tty
else
  skip "transform --check (examples/import-dump/output/shop)"
fi

# ---------------------------------------------------------------------------
# 4c. live database sides: diff db:a db:b, deploy the delta, catalogs match
# ---------------------------------------------------------------------------
if [ -d examples/diff-live-db ]; then
  note "load v1 -> live_a, v2 -> live_b"
  $PSQL -d postgres -c 'CREATE DATABASE live_a'
  $PSQL -d postgres -c 'CREATE DATABASE live_b'
  $PSQL -d live_a -v ON_ERROR_STOP=1 -f examples/import-dump/input/shop.v1.sql
  $PSQL -d live_b -v ON_ERROR_STOP=1 -f examples/diff-migration/input/shop.v2.sql

  note "pgpm diff db:live_a db:live_b -> live delta module"
  rm -rf examples/diff-live-db/output
  pgpm diff db:live_a db:live_b --emit-migration examples/diff-live-db/output --pkg shop-live-delta --no-tty

  deploy_module examples/diff-live-db/output/shop-live-delta live_a
  assert_same_catalog live_a live_b "live_a + live delta vs live_b"
else
  skip "live-db diff check (examples/diff-live-db)"
fi

# ---------------------------------------------------------------------------
# 4d. port-supabase: cross-shape transpilation, both directions
# ---------------------------------------------------------------------------
if [ -d examples/port-supabase ]; then
  note "re-materialize port-supabase outputs (drift gate)"
  rm -rf examples/port-supabase/output
  (cd examples/port-supabase \
    && pgpm materialize vendor-app-materialized --output output/vendor-app-materialized --no-tty \
    && pgpm materialize vendor-app-native-materialized --output output/vendor-app-native-materialized --no-tty)
  if ! git diff --exit-code -- examples/port-supabase/output; then
    echo "FAIL: committed port-supabase outputs drifted from re-materialization"
    exit 1
  fi
  note "port-supabase outputs are drift-free"

  # forward: Supabase shape -> plain PostgreSQL (generic provider substitutes auth)
  deploy_module examples/port-supabase/input/auth-provider port_pgpm
  deploy_module examples/port-supabase/output/vendor-app-materialized port_pgpm

  # reverse: ported shape -> back onto the vendor's native subsystem
  note "seed port_vendor with the native auth/extensions environment"
  $PSQL -d postgres -c 'CREATE DATABASE port_vendor'
  $PSQL -d port_vendor -v ON_ERROR_STOP=1 -f examples/port-supabase/input/native-env.sql
  deploy_module examples/port-supabase/output/vendor-app-native-materialized port_vendor

  revert_module examples/port-supabase/output/vendor-app-materialized port_pgpm
  revert_module examples/port-supabase/input/auth-provider port_pgpm
  assert_db_clean port_pgpm
  revert_module examples/port-supabase/output/vendor-app-native-materialized port_vendor
  leftovers=$($PSQL -d port_vendor -tAc \
    "SELECT string_agg(nspname, ',') FROM pg_namespace WHERE nspname = 'app'")
  if [ -n "$leftovers" ]; then
    echo "FAIL: revert left the app schema behind in port_vendor"
    exit 1
  fi
  note "port_vendor left clean after revert (native env retained)"
else
  skip "port-supabase (examples/port-supabase)"
fi

# ---------------------------------------------------------------------------
# 5. full revert leaves each database clean
# ---------------------------------------------------------------------------
for pkg in "${DEPLOYED_VARIANTS[@]}"; do
  revert_module "$pkg" "${VARIANT_DB[$pkg]}"
  assert_db_clean "${VARIANT_DB[$pkg]}"
done
if [ "$DEPLOYED_PARTITION" = 1 ]; then
  revert_module examples/partition-security/output/shop-security shop_partitioned
  revert_module examples/partition-security/output/shop-app shop_partitioned
  assert_db_clean shop_partitioned
fi
for entry in "${IMPORT_EQUIV_DEPLOYED[@]}"; do
  IFS='|' read -r pkg_dir db <<< "$entry"
  revert_module "$pkg_dir" "$db"
  assert_db_clean "$db"
done

note "acceptance suite complete"
