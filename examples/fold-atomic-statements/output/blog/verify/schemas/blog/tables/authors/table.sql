-- Verify: schemas/blog/tables/authors/table


SELECT 1/(CASE WHEN to_regclass('blog.authors') IS NOT NULL THEN 1 ELSE 0 END);


