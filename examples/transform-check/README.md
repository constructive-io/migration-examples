# transform-check — the built-in lossless-transform oracle

**Input:** [`../import-dump/output/shop/`](../import-dump/output/shop).

**Output:** nothing committed — `--check` is an *oracle*: after re-projecting the module it deploys both the original and the transformed output into scratch databases and asserts the catalogs are equivalent, then tears everything down.

```sh
pgpm transform --granularity consolidated --check \
  --cwd examples/import-dump/output/shop --out /tmp/roundtrip
```

This is the same proof our acceptance suite does externally, built into the CLI. CI runs it as part of the suite.
