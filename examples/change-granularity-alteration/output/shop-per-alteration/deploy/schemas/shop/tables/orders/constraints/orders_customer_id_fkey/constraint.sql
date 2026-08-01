-- Deploy: schemas/shop/tables/orders/constraints/orders_customer_id_fkey/constraint
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table
-- requires: schemas/shop/tables/orders/columns/customer_id/column
-- requires: schemas/shop/tables/customers/constraints/customers_email_key/constraint


ALTER TABLE ONLY shop.orders 
  ADD CONSTRAINT orders_customer_id_fkey
    FOREIGN KEY(customer_id)
    REFERENCES shop.customers (id);

