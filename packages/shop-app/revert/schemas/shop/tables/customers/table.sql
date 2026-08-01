-- Revert: schemas/shop/tables/customers/table


COMMENT ON COLUMN shop.customers.email IS NULL;

COMMENT ON TABLE shop.customers IS NULL;

DROP TABLE shop.customers;


