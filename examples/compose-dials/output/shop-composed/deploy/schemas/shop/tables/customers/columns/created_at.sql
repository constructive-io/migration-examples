-- Deploy: schemas/shop/tables/customers/columns/created_at
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/customers/table


ALTER TABLE shop.customers 
  ADD COLUMN created_at timestamptz
    DEFAULT now()
    NOT NULL;

