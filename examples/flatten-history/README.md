# flatten-history — ADD / DROP / ALTER churn → flattened module

**Input:** [`input/inventory.churn.sql`](input/inventory.churn.sql) — an evolution log with real churn: a column is added and later dropped (`legacy_code`), NOT NULL is bolted on after the fact, constraints and an FK arrive one statement at a time.

**Output:** [`output/inventory/`](output/inventory) — the imported module. Late `ALTER COLUMN ... SET NOT NULL` folds into the column definition; the add→drop pair is preserved semantically (a `DROP COLUMN` rider after the folded `CREATE TABLE`), with an explicit warning that its revert isn't derivable (the prior state is unknown).

```sh
pgpm import examples/flatten-history/input/inventory.churn.sql --pkg inventory \
  --out examples/flatten-history/output
```

14 statements → 3 changes, 1 warning. This example pins down exactly how much history import flattens vs preserves — a natural place to watch the engine improve (e.g. eliding add→drop pairs entirely). CI deploys the module and loads the raw input fresh, asserting identical catalogs.
