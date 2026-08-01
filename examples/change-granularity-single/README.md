# change-granularity-single — the whole schema as one change

**Input:** [`../import-dump/input/shop.v1.sql`](../import-dump/input/shop.v1.sql) — the same raw dump as [import-dump](../import-dump).

**Output:** [`output/shop-single-change/`](output/shop-single-change) — the opposite extreme of [change-granularity-alteration](../change-granularity-alteration): the entire schema collapses into **one plan entry** (`module/init`) with one deploy/revert/verify triple. 53 statements → **1 change**.

```sh
pgpm import examples/import-dump/input/shop.v1.sql --pkg shop-single-change \
  --granularity consolidated --change-granularity single \
  --out examples/change-granularity-single/output
```

Useful as a "squash" projection — e.g. baselining a mature schema where per-object history no longer matters. CI proves the catalog is identical to every other variant.
