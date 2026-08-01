# pack-module — pgpm module → one packed SQL file

**Input:** [`../import-dump/output/shop/`](../import-dump/output/shop) — the pgpm module (dir with many files).

**Output:** [`output/shop.module.sql`](output/shop.module.sql) — the whole module deparsed in plan order into a single clean SQL script.

```sh
pgpm transform --granularity object --cwd examples/import-dump/output/shop \
  --out /tmp/roundtrip --emit-sql "$PWD/examples/pack-module/output/shop.module.sql"
```

The inverse of [import-dump](../import-dump): dump in, module out; module in, one file out. CI loads this file fresh and asserts it is catalog-identical to deploying the module.
