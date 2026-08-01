# diff-live-db — live databases as diff sides

**Input:** two **live databases** (`db:<name>`, or full `postgres://` URLs) — no files at all. Each side's schema is read via `pg_dump` and normalized through the same ingestion path as modules and SQL files.

**Output:** nothing committed — the migration module is generated at test time (this is the point: any pair of live databases can be diffed on demand).

```sh
# two live databases, e.g. loaded from the v1 and v2 dumps
pgpm diff db:live_a db:live_b --emit-migration examples/diff-live-db/output --pkg shop-live-delta
```

Because both sides go through pg_dump symmetrically, the delta matches the module-vs-module diff exactly (4 added / 1 removed / 3 changed for shop v1 vs v2). CI creates both databases, generates the delta live, deploys it onto the v1 database, and asserts the catalog then equals the v2 database.
