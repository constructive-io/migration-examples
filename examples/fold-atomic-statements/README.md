# fold-atomic-statements — atomic statement soup → grouped module

**Input:** [`input/blog.atomic.sql`](input/blog.atomic.sql) — a migration-log-style file: empty `CREATE TABLE ()` statements followed by one `ALTER TABLE ADD COLUMN` / `ADD CONSTRAINT` per statement, with foreign keys added last.

**Output:** [`output/blog/`](output/blog) — a pgpm module where each table is one change with a **fully folded `CREATE TABLE`**: columns, PK, UNIQUE and CHECK constraints inline, FKs as late `ALTER TABLE ONLY` constraints, and graph-derived `requires` between tables (authors → posts).

```sh
pgpm import examples/fold-atomic-statements/input/blog.atomic.sql --pkg blog \
  --out examples/fold-atomic-statements/output
```

16 statements → 3 changes, 0 warnings. The inverse of [granularity-atomic](../granularity-atomic): that example explodes a packed module into atomic statements; this one folds atomic statements back into a packed module. CI deploys the module and loads the raw input fresh, asserting identical catalogs.
