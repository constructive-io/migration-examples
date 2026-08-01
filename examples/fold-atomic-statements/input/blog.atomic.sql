CREATE SCHEMA blog;

CREATE TABLE blog.authors (
);

ALTER TABLE blog.authors ADD COLUMN id uuid DEFAULT gen_random_uuid() NOT NULL;
ALTER TABLE blog.authors ADD COLUMN email text NOT NULL;
ALTER TABLE blog.authors ADD COLUMN display_name text NOT NULL;
ALTER TABLE blog.authors ADD CONSTRAINT authors_pkey PRIMARY KEY (id);
ALTER TABLE blog.authors ADD CONSTRAINT authors_email_key UNIQUE (email);

CREATE TABLE blog.posts (
);

ALTER TABLE blog.posts ADD COLUMN id uuid DEFAULT gen_random_uuid() NOT NULL;
ALTER TABLE blog.posts ADD COLUMN author_id uuid NOT NULL;
ALTER TABLE blog.posts ADD COLUMN title text NOT NULL;
ALTER TABLE blog.posts ADD COLUMN body text;
ALTER TABLE blog.posts ADD COLUMN published_at timestamptz;
ALTER TABLE blog.posts ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
ALTER TABLE blog.posts ADD CONSTRAINT posts_title_check CHECK (char_length(title) > 0);
ALTER TABLE ONLY blog.posts ADD CONSTRAINT posts_author_id_fkey FOREIGN KEY (author_id) REFERENCES blog.authors(id) ON DELETE CASCADE;
