-- Revert: schemas/shop/tables/products/table


COMMENT ON TABLE shop.products IS NULL;

DROP TABLE shop.products;


