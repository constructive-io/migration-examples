# diff-migration — semantic diff → migration module + delta SQL

**Input:** [`../import-dump/output/shop/`](../import-dump/output/shop) (v1 as a module) vs [`input/shop.v2.sql`](input/shop.v2.sql) (evolved schema: +table, +column, -column, changed function body, +policy, -index, changed constraint).

**Output:** [`output/shop-v1-to-v2/`](output/shop-v1-to-v2) — the delta as a deployable pgpm migration module — and [`output/shop.v1-to-v2.sql`](output/shop.v1-to-v2.sql) — the same delta as one linear SQL file.

```sh
pgpm import examples/diff-migration/input/shop.v2.sql --pkg shop-v2 --out /tmp/v2mod
pgpm diff examples/import-dump/output/shop /tmp/v2mod/shop-v2 \
  --emit-migration examples/diff-migration/output --pkg shop-v1-to-v2 \
  --emit-sql examples/diff-migration/output/shop.v1-to-v2.sql --verify
```

The delta is one model; every `--emit-*` flag is a projection of it. Tables are compared column-by-column and constraint-by-constraint, so the delta is `ALTER TABLE`, not a rebuild. 4 added, 1 removed, 3 changed.

The v2 dump is first imported into a throwaway module so both sides go through the same normalization — diffing a module directly against a raw `.sql` file currently produces spurious deltas (see [constructive-planning#1340](https://github.com/constructive-io/constructive-planning/issues/1340)).
