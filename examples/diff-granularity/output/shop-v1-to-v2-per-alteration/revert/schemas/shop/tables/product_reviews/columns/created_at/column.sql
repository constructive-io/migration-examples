-- Revert: schemas/shop/tables/product_reviews/columns/created_at/column


ALTER TABLE shop.product_reviews DROP COLUMN created_at RESTRICT;


