# port-supabase — cross-shape transpilation, both directions

Vendored from
[constructive-io/supabase-test-suite](https://github.com/constructive-io/supabase-test-suite)'s
[`portability/`](https://github.com/constructive-io/supabase-test-suite/tree/main/portability)
demo so the whole story is self-contained here: take a package written against
one environment's conventions (Supabase's `auth` subsystem, `auth.uid()` RLS
accessors, the `extensions` schema) and mechanically re-shape it for another —
in **both directions**.

**Input:** [`input/vendor-app/`](input/vendor-app) — a Supabase-shaped module
(an `app.documents` table with an FK to `auth.users`, an RLS policy on
`owner = auth.uid()`, `extensions.uuid_generate_v4()` defaults) — plus
[`input/auth-provider/`](input/auth-provider), a tiny generic provider
(`app_auth.users` + `app_auth.current_user_id()`), and two apply-proxy
recipes ([`input/vendor-app-ported/pgpm.apply.json`](input/vendor-app-ported/pgpm.apply.json),
[`input/vendor-app-native/pgpm.apply.json`](input/vendor-app-native/pgpm.apply.json)).

**Read it in three files** — each side also has a packed single-file SQL
projection, the easiest way to see the transformation:

| File | Shape |
|---|---|
| [`input/vendor-app.sql`](input/vendor-app.sql) | Supabase shape: `auth.users`, `owner = auth.uid()`, `extensions.uuid_generate_v4()` |
| [`output/vendor-app-materialized.sql`](output/vendor-app-materialized.sql) | plain PostgreSQL: `app_auth.users`, `owner = app_auth.current_user_id()`, bare `uuid_generate_v4()` |
| [`output/vendor-app-native-materialized.sql`](output/vendor-app-native-materialized.sql) | ported back: `auth.uid()` and `extensions.*` restored |

```sh
pgpm transform --granularity object --emit-sql <file>.sql --cwd <module>
```

**Output modules:**

| Module | Direction | What changed |
|---|---|---|
| [`output/vendor-app-materialized/`](output/vendor-app-materialized) | Supabase → plain PostgreSQL | `auth` subsystem excluded; FK + RLS rebound onto the generic `app_auth` provider (`owner = app_auth.current_user_id()`); `extensions.uuid_generate_v4()` de-qualified to a bare call resolved from `uuid-ossp` |
| [`output/vendor-app-native-materialized/`](output/vendor-app-native-materialized) | plain PostgreSQL → Supabase | the inverse: provider references routed back onto native `auth.users` / `auth.uid()`; extension calls re-qualified into the `extensions` schema |

```sh
cd examples/port-supabase
pgpm materialize vendor-app-materialized --output output/vendor-app-materialized
pgpm materialize vendor-app-native-materialized --output output/vendor-app-native-materialized
```

An apply proxy (`pgpm.apply.json`) is a *recipe* — exclude a subsystem, route
surviving references onto a substitute, re-qualify extension symbols.
`pgpm materialize` ejects it into an ordinary module with the transforms baked
into the SQL. Subsystem exclusion is cascade-safe: it measures the external
surface of the excluded schema from the reference graph and refuses unless
every surviving reference has a substitute.

CI re-materializes both outputs (drift gate), deploys the ported module on
plain PostgreSQL (provider first), deploys the ported-back module onto a
seeded native environment ([`input/native-env.sql`](input/native-env.sql)),
verifies both, and reverts clean. The full test suite — contract measurement
against the real vendored Supabase schema, live RLS tests through the provider
accessor — lives in
[supabase-test-suite](https://github.com/constructive-io/supabase-test-suite/tree/main/portability).
