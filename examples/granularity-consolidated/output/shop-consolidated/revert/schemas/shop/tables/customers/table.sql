-- Revert: schemas/shop/tables/customers/table


REVOKE SELECT ON shop.customers FROM app_user RESTRICT;

COMMENT ON COLUMN shop.customers.email IS NULL;

COMMENT ON TABLE shop.customers IS NULL;

DROP TABLE shop.customers;


