-- Deploy: schemas/shop/tables/order_items/constraints/order_items/constraint
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/products/table
-- requires: schemas/shop/tables/order_items/table
-- requires: schemas/shop/tables/orders/constraints/orders/constraint


ALTER TABLE ONLY shop.order_items 
  ADD CONSTRAINT order_items_order_id_fkey
    FOREIGN KEY(order_id)
    REFERENCES shop.orders (id)
    ON DELETE CASCADE;

ALTER TABLE ONLY shop.order_items 
  ADD CONSTRAINT order_items_product_id_fkey
    FOREIGN KEY(product_id)
    REFERENCES shop.products (id);

