-- Deploy: schemas/blog/tables/posts/table
-- made with <3 @ constructive.io

-- requires: schemas/blog/schema
-- requires: schemas/blog/tables/authors/table


CREATE TABLE blog.posts (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  author_id uuid NOT NULL,
  title text NOT NULL,
  body text,
  published_at timestamptz,
  CONSTRAINT posts_pkey PRIMARY KEY (id),
  CONSTRAINT posts_title_check 
    CHECK (char_length(title) > 0)
);

ALTER TABLE ONLY blog.posts 
  ADD CONSTRAINT posts_author_id_fkey
    FOREIGN KEY(author_id)
    REFERENCES blog.authors (id)
    ON DELETE CASCADE;

