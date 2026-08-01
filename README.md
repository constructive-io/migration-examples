# migration-examples

<p align="center" width="100%">
  <img height="250" src="https://raw.githubusercontent.com/constructive-io/constructive/refs/heads/main/assets/outline-logo.svg" />
</p>

<p align="center" width="100%">
  <a href="https://github.com/constructive-io/migration-examples/actions/workflows/ci.yml">
    <img height="20" src="https://github.com/constructive-io/migration-examples/actions/workflows/ci.yml/badge.svg" />
  </a>
</p>

End-to-end demonstration of **pgpm schema projections**. Every PostgreSQL
schema source — a raw `pg_dump`, a migration log, a pgpm module, a live
database — is parsed into ASTs and normalized to one canonical semantic
model; every output shape is a projection of that model. This repo is both
the worked examples and the acceptance test: CI deploys every projection and
proves they all produce the identical catalog.

- 🌳 **AST in, AST out** — every statement is parsed with the real PostgreSQL
  parser and deparsed back to SQL; no regex or string rewriting anywhere.
- 🔑 **Identity-keyed semantic model** — objects are keyed by
  kind/schema/name; whitespace, statement order, constraint placement, and
  authoring granularity all normalize away.
- 🧩 **Statement folding** — `CREATE TABLE ()` + n×`ALTER TABLE ADD COLUMN` +
  late constraints fold into one canonical `CREATE TABLE`; the inverse
  projection explodes it back to one statement per alteration.
- 🎚️ **Orthogonal projections** — statement shape (`--granularity`), change
  distribution (`--change-granularity`), path naming (`--naming`), and package
  partitioning (`--partition`) compose freely; every combination is
  semantically invariant.
- 🔍 **Semantic diff** — two sources (module, SQL file, or live database)
  diff as identity-keyed object sets: tables compare column-by-column and
  constraint-by-constraint, so changes emit `ALTER TABLE`, not a rebuild.
- 📦 **Uniform output projections** — the same model emits a pgpm module, a
  single linear SQL script, or a content-addressed bundle
  (`--emit-migration` / `--emit-sql` / `--emit-bundle`), from any command.
- 🔌 **Cross-shape portability** — cascade-safe subsystem exclusion with
  reference rebinding: a Supabase-shaped package re-targets plain PostgreSQL
  (and back) by routing `auth.users` FKs and `auth.uid()` call sites onto a
  substitute provider (`pgpm materialize`).
- ⚖️ **Catalog-equivalence proofs** — CI deploys every projection into its own
  scratch database and asserts byte-identical normalized catalogs, plus clean
  `pgpm verify` / `pgpm revert` cycles for every generated change.

Built on [pgpm](https://github.com/constructive-io/constructive/tree/main/pgpm):
[`@pgpmjs/transform`](https://github.com/constructive-io/constructive/tree/main/pgpm/transform)
(the projection engine),
[`@pgpmjs/import`](https://github.com/constructive-io/constructive/tree/main/pgpm/import) /
[`@pgpmjs/diff`](https://github.com/constructive-io/constructive/tree/main/pgpm/diff)
(source loading and semantic diff),
[`@pgpmjs/naming-spec`](https://github.com/constructive-io/constructive/tree/main/pgpm/naming-spec)
(identity → path projection), and the
[pgpm CLI](https://github.com/constructive-io/constructive/tree/main/pgpm/cli).

Planning issues:
[constructive-planning#1340](https://github.com/constructive-io/constructive-planning/issues/1340)
(import / transform / diff + this example repo),
[constructive-planning#1344](https://github.com/constructive-io/constructive-planning/issues/1344)
(the example matrix and this layout), and
[constructive-planning#1329](https://github.com/constructive-io/constructive-planning/issues/1329)
(the projections roadmap).

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
| [change-granularity-alteration](examples/change-granularity-alteration) | [raw pg_dump](examples/import-dump/input/shop.v1.sql) | [one change per column/constraint](examples/change-granularity-alteration/output/shop-per-alteration) (53 statements → 54 changes) |
| [change-granularity-single](examples/change-granularity-single) | [raw pg_dump](examples/import-dump/input/shop.v1.sql) | [the whole schema as one change](examples/change-granularity-single/output/shop-single-change) (53 statements → 1 change) |
| [naming-flat](examples/naming-flat) | [the module](examples/import-dump/output/shop) | [flat change-path layout](examples/naming-flat/output/shop-object) (`--naming flat`) |
| [emit-bundle](examples/emit-bundle) | [the module](examples/import-dump/output/shop) | [content-addressed bundle](examples/emit-bundle/output/shop.bundle.tar.gz) powering `pgpm deploy --fast` |
| [append-migration](examples/append-migration) | v1→v2 delta + [shop.v3.sql](examples/append-migration/input/shop.v3.sql) | [one living migration module](examples/append-migration/output/shop-migrations) (`diff --append-module`) covering v1→v3 |
| [diff-live-db](examples/diff-live-db) | two **live databases** (`db:a` vs `db:b`) | migration module generated on demand at test time |
| [compose-projections](examples/compose-projections) | [raw pg_dump](examples/import-dump/input/shop.v1.sql) | [all projections at once](examples/compose-projections/output/shop-composed) (atomic × per-alteration × flat) + [linear SQL](examples/compose-projections/output/shop-composed.sql), one command |
| [diff-granularity](examples/diff-granularity) | the v1 module vs v2 | [per-alteration migration](examples/diff-granularity/output/shop-v1-to-v2-per-alteration) — same delta, 7 → 17 independently revertible changes |
| [diff-bundle](examples/diff-bundle) | the v1 module vs v2 | [the delta as a content-addressed bundle](examples/diff-bundle/output/shop.v1-to-v2.bundle.tar.gz) |
| [transform-check](examples/transform-check) | [the module](examples/import-dump/output/shop) | nothing — the CLI's built-in scratch-DB lossless-transform oracle |
| [diff-module-vs-db](examples/diff-module-vs-db) | a module vs a **live database** | *blocked* — documents the mixed-side normalization asymmetry + workaround |
| [port-supabase](examples/port-supabase) | [Supabase-shaped app](examples/port-supabase/input/vendor-app) (`auth.uid()` RLS, `extensions.*`) + [apply recipes](examples/port-supabase/input/vendor-app-ported/pgpm.apply.json) | [ported to plain PostgreSQL](examples/port-supabase/output/vendor-app-materialized.sql) and [ported back to Supabase shape](examples/port-supabase/output/vendor-app-native-materialized.sql) (single-file views; `pgpm materialize`, both directions) |

See the full combination matrix in
[constructive-planning#1344](https://github.com/constructive-io/constructive-planning/issues/1344);
the remaining unbuilt rows are blocked on known `pgpm diff` raw-SQL
normalization bugs or on CLI features that haven't landed yet.

## Layout

```
migration-examples/               # pgpm init workspace
├── examples/
│   └── <name>/
│       ├── README.md             # the one command + what projection it demonstrates
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
