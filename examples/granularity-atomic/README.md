# granularity-atomic — the granularity dial, turned all the way down

**Input:** [`../import-dump/output/shop/`](../import-dump/output/shop)

**Output:** [`output/shop-atomic/`](output/shop-atomic) — same schema, one statement per change: every table is an empty `CREATE TABLE` followed by one `ALTER TABLE` per column and constraint.

```sh
pgpm transform --granularity atomic --cwd examples/import-dump/output/shop \
  --out "$PWD/examples/granularity-atomic/output"
```
