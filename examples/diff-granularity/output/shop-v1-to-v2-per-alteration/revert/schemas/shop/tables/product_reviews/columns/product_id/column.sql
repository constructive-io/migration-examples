-- Revert: schemas/shop/tables/product_reviews/columns/product_id/column


ALTER TABLE shop.product_reviews DROP COLUMN product_id RESTRICT;


