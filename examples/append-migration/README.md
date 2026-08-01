# append-migration — a living migration module (v1 → v2 → v3)

**Input:** [`../import-dump/output/shop/`](../import-dump/output/shop) (v1), [`../diff-migration/input/shop.v2.sql`](../diff-migration/input/shop.v2.sql) (v2), and [`input/shop.v3.sql`](input/shop.v3.sql) (v3 = v2 + a `shop.coupons` table).

**Output:** [`output/shop-migrations/`](output/shop-migrations) — ONE migration module that accumulates deltas over time: the v1→v2 delta emitted first, then the v2→v3 delta **appended** into the same module (existing changes, scripts, and `.control` untouched).

```sh
# v1 -> v2: emit the initial migration module
pgpm import examples/diff-migration/input/shop.v2.sql --pkg shop-v2 --out /tmp/v2mod
pgpm diff examples/import-dump/output/shop /tmp/v2mod/shop-v2 \
  --emit-migration examples/append-migration/output --pkg shop-migrations

# v2 -> v3: append the next delta into the SAME module
pgpm import examples/append-migration/input/shop.v3.sql --pkg shop-v3 --out /tmp/v3mod
pgpm diff /tmp/v2mod/shop-v2 /tmp/v3mod/shop-v3 \
  --append-module examples/append-migration/output/shop-migrations
```

CI deploys shop@v1 then `shop-migrations` and asserts the catalog equals v3 loaded fresh — one deploy covers the whole v1→v3 history.

Note: appended changes whose derived path collides with an existing change in the module (e.g. two deltas both altering `shop.orders`) are currently skipped with a notice rather than sequenced — tracked upstream in [constructive-planning#1344](https://github.com/constructive-io/constructive-planning/issues/1344).
