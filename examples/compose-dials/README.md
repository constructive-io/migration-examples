# compose-dials — every dial in one command

**Input:** [`../import-dump/input/shop.v1.sql`](../import-dump/input/shop.v1.sql) — the same raw dump as [import-dump](../import-dump).

**Output:** [`output/shop-composed/`](output/shop-composed) + [`output/shop-composed.sql`](output/shop-composed.sql) — one `pgpm import` run stacking four dials and an extra projection: **atomic** statement shape × **per-alteration** change distribution × **flat** naming, plus the same model projected to a single linear SQL file. 53 statements → 54 changes and one packed script, from one command.

```sh
pgpm import examples/import-dump/input/shop.v1.sql --pkg shop-composed \
  --granularity atomic --change-granularity alteration --naming flat \
  --out examples/compose-dials/output \
  --emit-sql "$PWD/examples/compose-dials/output/shop-composed.sql"
```

The dials are orthogonal projections of one identity-keyed model, so any combination is semantically invariant. CI deploys the composed module and asserts the catalog is identical to every other variant.
