-- Revert: schemas/shop/tables/product_reviews/table


COMMENT ON TABLE shop.product_reviews IS NULL;
ALTER TABLE ONLY shop.product_reviews DROP CONSTRAINT product_reviews_customer_id_fkey RESTRICT;
ALTER TABLE ONLY shop.product_reviews DROP CONSTRAINT product_reviews_product_id_fkey RESTRICT;
REVOKE SELECT, INSERT ON shop.product_reviews FROM app_user RESTRICT;
DROP TABLE shop.product_reviews;


