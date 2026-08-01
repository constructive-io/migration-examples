# naming-flat — the naming dial

**Input:** [`../import-dump/output/shop/`](../import-dump/output/shop)

**Output:** [`output/shop-object/`](output/shop-object) — the same module re-projected with `--naming flat`: leaf changes lose their kind-suffix directory (`.../order_total.sql` instead of `.../order_total/procedure.sql`). Same changes, same plan, same catalog — only the file layout dial moves.

```sh
pgpm transform --granularity object --naming flat \
  --cwd examples/import-dump/output/shop \
  --out "$PWD/examples/naming-flat/output"
```
