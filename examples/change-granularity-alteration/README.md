# change-granularity-alteration — one change per column / constraint

**Input:** [`../import-dump/input/shop.v1.sql`](../import-dump/input/shop.v1.sql) — the same raw dump as [import-dump](../import-dump).

**Output:** [`output/shop-per-alteration/`](output/shop-per-alteration) — every `ADD COLUMN` / `ADD CONSTRAINT` is its **own plan entry** with its own deploy/revert/verify and graph-derived requires (paths like `schemas/shop/tables/customers/columns/email/column`, `.../constraints/customers_pkey/constraint`); unnamed constraints are auto-named with their Postgres defaults so each is independently revertible. 53 statements → **54 changes**.

```sh
pgpm import examples/import-dump/input/shop.v1.sql --pkg shop-per-alteration \
  --granularity atomic --change-granularity alteration \
  --out examples/change-granularity-alteration/output
```

`--change-granularity` is the second granularity axis, orthogonal to `--granularity`: `--granularity` shapes the SQL *within* a change, `--change-granularity` distributes statements *across* plan entries. CI proves this module deploys to the identical catalog as every other variant.
