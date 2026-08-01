#!/usr/bin/env bash
# Acceptance test for the dials pipeline examples.
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
# 4. shop@v1 + shop-v1-to-v2 migration == shop.v2.sql deployed fresh
# ---------------------------------------------------------------------------
if [ -d examples/diff-migration/output/shop-v1-to-v2 ] && [ -d examples/import-dump/output/shop ]; then
  deploy_module examples/import-dump/output/shop shop_migrated
  deploy_module examples/diff-migration/output/shop-v1-to-v2 shop_migrated

  note "load examples/diff-migration/input/shop.v2.sql fresh -> shop_v2_fresh"
  $PSQL -d postgres -c 'CREATE DATABASE shop_v2_fresh'
  $PSQL -d shop_v2_fresh -f examples/diff-migration/input/shop.v2.sql

  assert_same_catalog shop_migrated shop_v2_fresh "v1 + migration vs v2 fresh"

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

note "acceptance suite complete"
