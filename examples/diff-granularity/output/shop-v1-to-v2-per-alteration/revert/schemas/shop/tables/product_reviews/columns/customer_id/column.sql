-- Revert: schemas/shop/tables/product_reviews/columns/customer_id/column


ALTER TABLE shop.product_reviews DROP COLUMN customer_id RESTRICT;


