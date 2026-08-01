-- Revert: schemas/blog/tables/posts/table


ALTER TABLE ONLY blog.posts 
  DROP CONSTRAINT posts_author_id_fkey RESTRICT;

DROP TABLE blog.posts;


