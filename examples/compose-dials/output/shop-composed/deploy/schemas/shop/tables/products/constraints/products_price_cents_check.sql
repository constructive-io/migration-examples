-- Deploy: schemas/shop/tables/products/constraints/products_price_cents_check
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/products/table


ALTER TABLE shop.products 
  ADD CONSTRAINT products_price_cents_check 
    CHECK (price_cents >= 0);

COMMENT ON TABLE shop.products IS 'Sellable products with price in cents.';

GRANT SELECT ON shop.products TO app_user;

