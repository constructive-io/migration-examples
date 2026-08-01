# diff-granularity — projections applied to a migration

**Input:** [`../import-dump/output/shop/`](../import-dump/output/shop) (v1) vs [`../diff-migration/input/shop.v2.sql`](../diff-migration/input/shop.v2.sql) (v2, imported first) — the same pair as [diff-migration](../diff-migration).

**Output:** [`output/shop-v1-to-v2-per-alteration/`](output/shop-v1-to-v2-per-alteration) — the same v1→v2 delta, but emitted with `--granularity atomic --change-granularity alteration`: every added column/constraint of the delta is its own independently revertible change. The object-granularity migration has 7 changes; this one has **17**.

```sh
pgpm import examples/diff-migration/input/shop.v2.sql --pkg shop-v2 --out /tmp/v2mod
pgpm diff examples/import-dump/output/shop /tmp/v2mod/shop-v2 \
  --emit-migration examples/diff-granularity/output --pkg shop-v1-to-v2-per-alteration \
  --granularity atomic --change-granularity alteration
```

CI deploys shop@v1 + this migration and asserts the catalog equals v2 loaded fresh — same oracle as the object-granularity migration.
