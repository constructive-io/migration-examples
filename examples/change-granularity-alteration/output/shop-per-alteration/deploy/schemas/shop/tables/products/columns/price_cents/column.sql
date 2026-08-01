-- Deploy: schemas/shop/tables/products/columns/price_cents/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/products/table


ALTER TABLE shop.products 
  ADD COLUMN price_cents int
    NOT NULL;

