# import-granularity — choose granularity at import time

**Input:** [`../import-dump/input/shop.v1.sql`](../import-dump/input/shop.v1.sql) — the same raw dump as [import-dump](../import-dump).

**Output:** [`output/shop-atomic-direct/`](output/shop-atomic-direct) — imported straight to **atomic** granularity in one step (no intermediate object-granularity module): each table change is an empty `CREATE TABLE` plus one `ALTER TABLE` per column/constraint.

```sh
pgpm import examples/import-dump/input/shop.v1.sql --pkg shop-atomic-direct \
  --granularity atomic --out examples/import-granularity/output
```

Demonstrates that the projections compose with any entry point: `import --granularity atomic` ≡ `import` then `transform --granularity atomic`. CI proves the catalog is identical to every other variant.
