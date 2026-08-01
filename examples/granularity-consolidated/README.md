# granularity-consolidated — the granularity dial, turned all the way up

**Input:** [`../import-dump/output/shop/`](../import-dump/output/shop)

**Output:** [`output/shop-consolidated/`](output/shop-consolidated) — same schema, a minimal number of consolidated changes: compact history, identical catalog.

```sh
pgpm transform --granularity consolidated --cwd examples/import-dump/output/shop \
  --out "$PWD/examples/granularity-consolidated/output"
```
