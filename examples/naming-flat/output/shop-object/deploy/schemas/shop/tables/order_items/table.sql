-- Deploy: schemas/shop/tables/order_items/table
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table
-- requires: schemas/shop/tables/products/table


CREATE TABLE shop.order_items (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  order_id uuid NOT NULL,
  product_id uuid NOT NULL,
  quantity int DEFAULT 1 NOT NULL,
  unit_price_cents int NOT NULL,
  CONSTRAINT order_items_pkey PRIMARY KEY (id)
);

ALTER TABLE ONLY shop.order_items 
  ADD CONSTRAINT order_items_order_id_fkey
    FOREIGN KEY(order_id)
    REFERENCES shop.orders (id)
    ON DELETE CASCADE;

ALTER TABLE ONLY shop.order_items 
  ADD CONSTRAINT order_items_product_id_fkey
    FOREIGN KEY(product_id)
    REFERENCES shop.products (id);

GRANT SELECT, INSERT ON shop.order_items TO app_user;

