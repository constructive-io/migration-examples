# emit-bundle — module → content-addressed bundle (+ fast deploy)

**Input:** [`../import-dump/output/shop/`](../import-dump/output/shop)

**Output:** [`output/shop.bundle.tar.gz`](output/shop.bundle.tar.gz) — the whole module projected into a single content-addressed archive (`pgpm-bundle.json`: manifest, deploy order, and every change's scripts).

```sh
pgpm transform --granularity object --cwd examples/import-dump/output/shop \
  --out /tmp/roundtrip --emit-bundle "$PWD/examples/emit-bundle/output/shop.bundle.tar.gz"
```

Bundles power `pgpm deploy --fast`: one-shot SQL plus a bulk migration ledger, reading a module's verified `sql/*.bundle.tar.gz` artifact when present and building it from `deploy/` when not. CI deploys the shop module with `--fast` and asserts the catalog is identical to the normal change-by-change deploy.
