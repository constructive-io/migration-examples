-- Deploy: schemas/shop/tables/order_items/constraints/order_items_order_id_fkey
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table
-- requires: schemas/shop/tables/order_items/table
-- requires: schemas/shop/tables/order_items/columns/order_id


ALTER TABLE ONLY shop.order_items 
  ADD CONSTRAINT order_items_order_id_fkey
    FOREIGN KEY(order_id)
    REFERENCES shop.orders (id)
    ON DELETE CASCADE;

