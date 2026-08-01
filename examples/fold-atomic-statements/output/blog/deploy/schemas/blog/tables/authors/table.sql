-- Deploy: schemas/blog/tables/authors/table
-- made with <3 @ constructive.io

-- requires: schemas/blog/schema


CREATE TABLE blog.authors (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  email text NOT NULL,
  display_name text NOT NULL,
  CONSTRAINT authors_pkey PRIMARY KEY (id),
  CONSTRAINT authors_email_key 
    UNIQUE (email)
);

