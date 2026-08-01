-- Revert: schemas/shop/tables/products/constraints/products_price_cents_check/constraint


REVOKE SELECT ON shop.products FROM app_user RESTRICT;

COMMENT ON TABLE shop.products IS NULL;

ALTER TABLE shop.products 
  DROP CONSTRAINT products_price_cents_check RESTRICT;


