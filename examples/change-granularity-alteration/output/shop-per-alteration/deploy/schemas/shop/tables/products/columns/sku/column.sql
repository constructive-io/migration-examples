-- Deploy: schemas/shop/tables/products/columns/sku/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/products/table


ALTER TABLE shop.products 
  ADD COLUMN sku text
    NOT NULL;

