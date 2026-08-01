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
#      resulting catalog equals sources/shop.v2.sql loaded fresh
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
catalog_dump() {
  local db="$1"
  pg_dump --schema-only --no-owner --exclude-schema 'pgpm*' "$db" \
    | grep -vE '^(--|SET |SELECT pg_catalog\.set_config|\\)' \
    | grep -v '^[[:space:]]*$'
}

deploy_module() {
  local pkg_dir="$1" db="$2"
  note "deploy $pkg_dir -> $db"
  (cd "$pkg_dir" && pgpm deploy --createdb --database "$db" --yes --no-tty)
  note "verify $pkg_dir on $db"
  (cd "$pkg_dir" && pgpm verify --database "$db" --no-tty)
}

revert_module() {
  local pkg_dir="$1" db="$2"
  note "revert $pkg_dir on $db"
  (cd "$pkg_dir" && pgpm revert --database "$db" --yes --no-tty)
  # after a full revert, no non-pgpm user schemas may remain
  local leftovers
  leftovers=$($PSQL -d "$db" -tAc \
    "SELECT string_agg(nspname, ',') FROM pg_namespace
     WHERE nspname NOT LIKE 'pg_%'
       AND nspname NOT IN ('information_schema', 'public')
       AND nspname NOT LIKE 'pgpm%'")
  if [ -n "$leftovers" ]; then
    echo "FAIL: revert of $pkg_dir left schemas behind: $leftovers"
    exit 1
  fi
  note "revert of $pkg_dir left the database clean"
}

assert_same_catalog() {
  local db_a="$1" db_b="$2" label="$3"
  note "catalog compare: $db_a vs $db_b ($label)"
  if ! diff <(catalog_dump "$db_a") <(catalog_dump "$db_b"); then
    echo "FAIL: catalog mismatch between $db_a and $db_b ($label)"
    exit 1
  fi
  note "catalogs identical ($label)"
}

# ---------------------------------------------------------------------------
# 1+2. deploy + verify every variant into its own scratch database
# ---------------------------------------------------------------------------
declare -A VARIANT_DB=(
  [packages/shop]=shop_object
  [packages/shop-atomic]=shop_atomic
  [packages/shop-consolidated]=shop_consolidated
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
if [ -d packages/shop-security ]; then
  deploy_module packages/shop-app shop_partitioned
  deploy_module packages/shop-security shop_partitioned
  DEPLOYED_PARTITION=1
else
  skip "packages/shop-app + packages/shop-security"
  DEPLOYED_PARTITION=0
fi

# ---------------------------------------------------------------------------
# 3. catalog equivalence across variants
# ---------------------------------------------------------------------------
if [ -d packages/shop ]; then
  for pkg in "${DEPLOYED_VARIANTS[@]}"; do
    [ "$pkg" = packages/shop ] && continue
    assert_same_catalog shop_object "${VARIANT_DB[$pkg]}" "object vs ${pkg#packages/}"
  done
  if [ "$DEPLOYED_PARTITION" = 1 ]; then
    assert_same_catalog shop_object shop_partitioned "object vs partitioned"
  fi
else
  skip "catalog equivalence (packages/shop)"
fi

# ---------------------------------------------------------------------------
# 4. shop@v1 + shop-v1-to-v2 migration == shop.v2.sql deployed fresh
# ---------------------------------------------------------------------------
if [ -d packages/shop-v1-to-v2 ] && [ -d packages/shop ]; then
  deploy_module packages/shop shop_migrated
  deploy_module packages/shop-v1-to-v2 shop_migrated

  note "load sources/shop.v2.sql fresh -> shop_v2_fresh"
  $PSQL -d postgres -c 'CREATE DATABASE shop_v2_fresh'
  $PSQL -d shop_v2_fresh -f sources/shop.v2.sql

  assert_same_catalog shop_migrated shop_v2_fresh "v1 + migration vs v2 fresh"
else
  skip "v1 -> v2 migration check (packages/shop-v1-to-v2)"
fi

# ---------------------------------------------------------------------------
# 5. full revert leaves each database clean
# ---------------------------------------------------------------------------
for pkg in "${DEPLOYED_VARIANTS[@]}"; do
  revert_module "$pkg" "${VARIANT_DB[$pkg]}"
done
if [ "$DEPLOYED_PARTITION" = 1 ]; then
  revert_module packages/shop-security shop_partitioned
  revert_module packages/shop-app shop_partitioned
fi

note "acceptance suite complete"
