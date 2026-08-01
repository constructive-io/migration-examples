-- Deploy: schemas/shop/tables/products/columns/description/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/products/table


ALTER TABLE shop.products 
  ADD COLUMN description text;

