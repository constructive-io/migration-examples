# partition-security — the partition dial

**Input:** [`../import-dump/output/shop/`](../import-dump/output/shop) + [`input/partition.json`](input/partition.json)

**Output:** [`output/shop-app/`](output/shop-app) + [`output/shop-security/`](output/shop-security) — the module split into two packages: RLS policies and grants land in `shop-security`, everything else in `shop-app`, with derived cross-package `requires` (`shop-app:schemas/shop/tables/orders/table`-style) so `shop-security` deploys on top of `shop-app`.

```sh
pgpm transform --granularity object \
  --partition "$PWD/examples/partition-security/input/partition.json" \
  --cwd examples/import-dump/output/shop \
  --out "$PWD/examples/partition-security/output"
```

16 changes in shop-app, 6 (grants + the RLS policy) in shop-security.
