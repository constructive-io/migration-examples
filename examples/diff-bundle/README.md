# diff-bundle — the delta as a content-addressed bundle

**Input:** [`../import-dump/output/shop/`](../import-dump/output/shop) (v1) vs shop-v2 (imported from [`../diff-migration/input/shop.v2.sql`](../diff-migration/input/shop.v2.sql)).

**Output:** [`output/shop.v1-to-v2.bundle.tar.gz`](output/shop.v1-to-v2.bundle.tar.gz) — the v1→v2 delta projected into a single content-addressed archive (`pgpm-bundle.json`: manifest, deploy order, and every migration change's scripts), the same artifact format `pgpm deploy --fast` consumes.

```sh
pgpm diff examples/import-dump/output/shop /tmp/v2mod/shop-v2 --pkg shop-v1-to-v2 \
  --emit-bundle "$PWD/examples/diff-bundle/output/shop.v1-to-v2.bundle.tar.gz"
```

The delta is one model; `--emit-migration`, `--emit-sql`, and `--emit-bundle` are all projections of it and compose in a single run.
