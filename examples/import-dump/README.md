# import-dump — raw pg_dump → pgpm module

**Input:** [`input/shop.v1.sql`](input/shop.v1.sql) — a realistic `pg_dump --schema-only` dump (2 schemas, FKs, function, trigger, RLS, grants, sequence, comments).

**Output:** [`output/shop/`](output/shop) — a complete deployable pgpm module at **object** granularity: one change per database object, spec-derived change paths, graph-derived `requires`, generated revert/verify.

```sh
pgpm import examples/import-dump/input/shop.v1.sql --pkg shop \
  --out examples/import-dump/output
```

pg_dump preamble noise is skipped; grants and comments ride with their host object. 53 statements → 15 changes (12 preamble skipped, 0 warnings).
