CREATE SCHEMA app;

GRANT USAGE ON SCHEMA app TO authenticated;

CREATE TABLE app.documents (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner uuid NOT NULL,
  title text NOT NULL
);

ALTER TABLE app.documents 
  ADD CONSTRAINT documents_owner_fkey
    FOREIGN KEY(owner)
    REFERENCES app_auth.users (id);

GRANT SELECT, INSERT ON app.documents TO authenticated;

ALTER TABLE app.documents 
  ENABLE ROW LEVEL SECURITY;

CREATE POLICY documents_owner
  ON app.documents
  AS PERMISSIVE
  FOR ALL
  TO PUBLIC
  USING (
    owner = app_auth.current_user_id()
  );
