-- Verify: schemas/blog/tables/posts/table


SELECT 1/(CASE WHEN to_regclass('blog.posts') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'posts' AND constraint_name = 'posts_author_id_fkey' AND table_schema = 'blog') THEN 1 ELSE 0 END);


