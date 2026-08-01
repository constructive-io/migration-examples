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
(import / transform / diff + this example repo) and
[constructive-planning#1329](https://github.com/constructive-io/constructive-planning/issues/1329)
(three-dial roadmap).

## Layout

```
migration-examples/               # pgpm init workspace
├── sources/
│   ├── shop.v1.sql               # hand-written pg_dump-style dump: 2 schemas, FKs, function, trigger, RLS, grants, sequence, comments
│   └── shop.v2.sql               # evolved v1: +table, +column, -column, changed function body, +policy, -index, changed constraint
├── packages/
│   ├── shop/                     # canonical module, imported from the v1 dump (object granularity)
│   ├── shop-atomic/              # same schema, one change per statement
│   ├── shop-consolidated/        # same schema, consolidated changes
│   ├── shop-app/                 # partitioned: everything except security surface
│   ├── shop-security/            # partitioned: policies + grants (requires shop-app)
│   └── shop-v1-to-v2/            # generated migration module: v1 -> v2 delta
├── partition.json                # partition config used for shop-app / shop-security
├── scripts/acceptance.sh         # the CI acceptance suite
└── .github/workflows/ci.yml
```

## The pipeline, step by step

Each package below is **generated** by exactly one pgpm command, run from the
workspace root. Regenerate any of them the same way.

### 1. `packages/shop` — import the dump

```sh
pgpm import sources/shop.v1.sql --pkg shop --out packages
```

Parses the raw dump, classifies every statement, and emits a complete
deployable module at the default **object** granularity: one change per
database object, spec-derived change paths, graph-derived `requires`, and
generated revert/verify scripts. pg_dump preamble noise is skipped; grants and
comments ride with their host object.

> Status: generated — 53 statements → 15 changes (12 preamble statements skipped, 0 warnings).

### 2. `packages/shop-atomic` — the granularity dial, turned all the way down

```sh
pgpm transform --granularity atomic --cwd packages/shop --out packages/shop-atomic
```

Re-dials the canonical module so every statement is its own change: maximal
history granularity, same catalog.

> Status: pending.

### 3. `packages/shop-consolidated` — the granularity dial, turned all the way up

```sh
pgpm transform --granularity consolidated --cwd packages/shop --out packages/shop-consolidated
```

Re-dials the module into a minimal number of consolidated changes: compact
history, same catalog.

> Status: pending.

### 4. `packages/shop-app` + `packages/shop-security` — the partition dial

```sh
pgpm transform --granularity object --partition partition.json --cwd packages/shop --out packages
```

Splits the module into two packages driven by [partition.json](partition.json):
RLS policies and grants land in `shop-security`, everything else in
`shop-app`, with derived cross-package `requires` so `shop-security` deploys
on top of `shop-app`.

> Status: pending.

### 5. `packages/shop-v1-to-v2` — the diff

```sh
pgpm diff packages/shop sources/shop.v2.sql --emit-migration packages --pkg shop-v1-to-v2
```

Identity-keyed semantic diff between the v1 module and the v2 dump. Tables are
compared column-by-column and constraint-by-constraint, so the delta is
`ALTER TABLE`, not a rebuild. The delta is emitted as a normal pgpm module you
can deploy on top of v1.

> Status: pending.

## What CI proves

[`scripts/acceptance.sh`](scripts/acceptance.sh), run against a Postgres
service container:

1. every committed variant deploys into its own scratch database and passes
   `pgpm verify`;
2. all granularity/partition variants produce **byte-identical normalized
   catalogs** (`pg_dump --schema-only`, noise-stripped) — different shapes,
   same schema;
3. deploying shop@v1 then `shop-v1-to-v2` yields the same catalog as loading
   `sources/shop.v2.sql` fresh;
4. `pgpm revert` unwinds every module and leaves the database clean.

Checks whose packages haven't been generated yet are skipped with a notice,
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
