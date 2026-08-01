-- Deploy: schemas/shop/tables/products/columns/id/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/products/table


ALTER TABLE shop.products 
  ADD COLUMN id uuid
    DEFAULT gen_random_uuid()
    NOT NULL;

