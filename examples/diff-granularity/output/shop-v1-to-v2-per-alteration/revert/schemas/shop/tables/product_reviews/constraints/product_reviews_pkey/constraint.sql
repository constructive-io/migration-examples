-- Revert: schemas/shop/tables/product_reviews/constraints/product_reviews_pkey/constraint


ALTER TABLE shop.product_reviews DROP CONSTRAINT product_reviews_pkey RESTRICT;


