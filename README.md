# migration-examples

<p align="center" width="100%">
  <img height="250" src="https://raw.githubusercontent.com/constructive-io/constructive/refs/heads/main/assets/outline-logo.svg" />
</p>

<p align="center" width="100%">
  <a href="https://github.com/constructive-io/migration-examples/actions/workflows/ci.yml">
    <img height="20" src="https://github.com/constructive-io/migration-examples/actions/workflows/ci.yml/badge.svg" />
  </a>
</p>

End-to-end demonstration of the **pgpm "dials" pipeline**: take an arbitrary
`pg_dump --schema-only` SQL dump, turn it into a deployable pgpm module
(`pgpm import`), re-project that module at different granularities and
partitionings (`pgpm transform`), and generate a semantic migration between
two schema versions (`pgpm diff`). The CI suite is the acceptance test: every
variant deploys, all variants produce an **identical catalog**, and
v1 + generated migration equals v2 deployed fresh.

See the planning issues:
[constructive-planning#1340](https://github.com/constructive-io/constructive-planning/issues/1340)
(import / transform / diff + this example repo),
[constructive-planning#1344](https://github.com/constructive-io/constructive-planning/issues/1344)
(the example matrix and this layout), and
[constructive-planning#1329](https://github.com/constructive-io/constructive-planning/issues/1329)
(three-dial roadmap).

## The examples

Every example lives in `examples/<name>/` with an explicit `input/` and a
committed, generated `output/`, plus a README showing the one command that
produced it.

| Example | Input | Output |
|---|---|---|
| [import-dump](examples/import-dump) | [raw pg_dump](examples/import-dump/input/shop.v1.sql) | [pgpm module](examples/import-dump/output/shop) (deploy/revert/verify per object) |
| [pack-module](examples/pack-module) | [the module](examples/import-dump/output/shop) | [one packed SQL file](examples/pack-module/output/shop.module.sql) |
| [granularity-atomic](examples/granularity-atomic) | [the module](examples/import-dump/output/shop) | [same schema, one statement per change](examples/granularity-atomic/output/shop-atomic) |
| [granularity-consolidated](examples/granularity-consolidated) | [the module](examples/import-dump/output/shop) | [same schema, compact history](examples/granularity-consolidated/output/shop-consolidated) |
| [partition-security](examples/partition-security) | [the module](examples/import-dump/output/shop) + [partition.json](examples/partition-security/input/partition.json) | [shop-app](examples/partition-security/output/shop-app) + [shop-security](examples/partition-security/output/shop-security) with cross-package requires |
| [diff-migration](examples/diff-migration) | [the module (v1)](examples/import-dump/output/shop) vs [shop.v2.sql](examples/diff-migration/input/shop.v2.sql) | [migration module](examples/diff-migration/output/shop-v1-to-v2) + [delta as one SQL file](examples/diff-migration/output/shop.v1-to-v2.sql) |
| [fold-atomic-statements](examples/fold-atomic-statements) | [atomic statement soup](examples/fold-atomic-statements/input/blog.atomic.sql) (empty `CREATE TABLE ()` + one `ADD COLUMN` per statement) | [grouped module](examples/fold-atomic-statements/output/blog) with fully folded CREATE TABLEs |
| [flatten-history](examples/flatten-history) | [evolution log with churn](examples/flatten-history/input/inventory.churn.sql) (ADD then DROP column, late NOT NULL) | [flattened module](examples/flatten-history/output/inventory) |
| [import-granularity](examples/import-granularity) | [raw pg_dump](examples/import-dump/input/shop.v1.sql) | [atomic module in one step](examples/import-granularity/output/shop-atomic-direct) (`import --granularity atomic`) |
| [naming-flat](examples/naming-flat) | [the module](examples/import-dump/output/shop) | [flat change-path layout](examples/naming-flat/output/shop-object) (`--naming flat`) |
| [emit-bundle](examples/emit-bundle) | [the module](examples/import-dump/output/shop) | [content-addressed bundle](examples/emit-bundle/output/shop.bundle.tar.gz) powering `pgpm deploy --fast` |
| [append-migration](examples/append-migration) | v1→v2 delta + [shop.v3.sql](examples/append-migration/input/shop.v3.sql) | [one living migration module](examples/append-migration/output/shop-migrations) (`diff --append-module`) covering v1→v3 |
| [diff-live-db](examples/diff-live-db) | two **live databases** (`db:a` vs `db:b`) | migration module generated on demand at test time |

See the full combination matrix in
[constructive-planning#1344](https://github.com/constructive-io/constructive-planning/issues/1344);
the remaining unbuilt rows are blocked on known `pgpm diff` raw-SQL
normalization bugs or on CLI features that haven't landed yet.

## Layout

```
migration-examples/               # pgpm init workspace
├── examples/
│   └── <name>/
│       ├── README.md             # the one command + what dial it demonstrates
│       ├── input/                # source artifacts (hand-written)
│       └── output/               # generated artifacts (committed)
├── scripts/acceptance.sh         # the CI acceptance suite
└── .github/workflows/ci.yml
```

## What CI proves

[`scripts/acceptance.sh`](scripts/acceptance.sh), run against a Postgres
service container:

1. every committed module deploys into its own scratch database and passes
   `pgpm verify`;
2. all granularity/partition variants produce **byte-identical normalized
   catalogs** (`pg_dump --schema-only`, noise-stripped, table columns
   order-normalized) — different shapes, same schema;
3. loading the packed single-file projection (`pack-module`) fresh yields the
   same catalog as deploying the module;
4. deploying shop@v1 then `shop-v1-to-v2` yields the same catalog as loading
   `shop.v2.sql` fresh (and likewise for the linear delta SQL);
5. `pgpm revert` unwinds every module and leaves the database clean.

Checks whose outputs haven't been generated yet are skipped with a notice,
so CI is green at every stage of the incremental build-out.

## Running locally

```sh
pnpm install
pgpm docker start
eval "$(pgpm env)"
pgpm admin-users bootstrap --yes
pgpm admin-users add --test --yes
bash scripts/acceptance.sh
```
