-- Revert: schemas/shop/tables/coupons/table


COMMENT ON TABLE shop.coupons IS NULL;
DROP TABLE shop.coupons;


