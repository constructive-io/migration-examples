-- Revert: schemas/shop/tables/product_reviews/constraints/product_reviews_rating_check/constraint


ALTER TABLE shop.product_reviews DROP CONSTRAINT product_reviews_rating_check RESTRICT;


