-- Deploy: schemas/shop/tables/customers/columns/id/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/customers/table


ALTER TABLE shop.customers 
  ADD COLUMN id uuid
    DEFAULT gen_random_uuid()
    NOT NULL;

