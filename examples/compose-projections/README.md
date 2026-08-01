# compose-projections — every projection in one command

**Input:** [`../import-dump/input/shop.v1.sql`](../import-dump/input/shop.v1.sql) — the same raw dump as [import-dump](../import-dump).

**Output:** [`output/shop-composed/`](output/shop-composed) + [`output/shop-composed.sql`](output/shop-composed.sql) — one `pgpm import` run stacking four projections and an extra output: **atomic** statement shape × **per-alteration** change distribution × **flat** naming, plus the same model projected to a single linear SQL file. 53 statements → 54 changes and one packed script, from one command.

```sh
pgpm import examples/import-dump/input/shop.v1.sql --pkg shop-composed \
  --granularity atomic --change-granularity alteration --naming flat \
  --out examples/compose-projections/output \
  --emit-sql "$PWD/examples/compose-projections/output/shop-composed.sql"
```

The projections are orthogonal views of one identity-keyed model, so any combination is semantically invariant. CI deploys the composed module and asserts the catalog is identical to every other variant.
