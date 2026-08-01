# diff-module-vs-db — mixed sides (known limitation)

**Input:** a pgpm module (v1) vs a **live database** (v2).

**Status: blocked by a known normalization asymmetry.** Module-vs-module and db-vs-db diffs are exact (each pair normalizes symmetrically), but mixing a module side with a pg_dump-derived side currently produces spurious column-level deltas (e.g. `~cols: created_at, placed_at` from default-expression representation differences) and "changed beyond its type; emit a manual ALTER" warnings for columns that didn't change:

```sh
pgpm diff examples/import-dump/output/shop db:live_v2 --emit-migration /tmp/out --pkg shop-module-vs-db
# Changed (7): ... tables report ~cols that are identical in both sides
```

Workaround (what every other example does): bring both sides to the same representation first — import the database/dump into a throwaway module and diff module-vs-module ([diff-migration](../diff-migration)), or use two live databases ([diff-live-db](../diff-live-db)). Tracked upstream in [constructive-planning#1344](https://github.com/constructive-io/constructive-planning/issues/1344).
