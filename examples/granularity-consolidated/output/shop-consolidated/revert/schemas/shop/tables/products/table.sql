-- Revert: schemas/shop/tables/products/table


REVOKE SELECT ON shop.products FROM app_user RESTRICT;

COMMENT ON TABLE shop.products IS NULL;

DROP TABLE shop.products;


