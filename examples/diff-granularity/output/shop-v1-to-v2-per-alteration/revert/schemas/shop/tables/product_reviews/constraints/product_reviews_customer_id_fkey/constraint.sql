-- Revert: schemas/shop/tables/product_reviews/constraints/product_reviews_customer_id_fkey/constraint


REVOKE SELECT, INSERT ON shop.product_reviews FROM app_user RESTRICT;
COMMENT ON TABLE shop.product_reviews IS NULL;
ALTER TABLE ONLY shop.product_reviews DROP CONSTRAINT product_reviews_customer_id_fkey RESTRICT;


