-- Deploy: schemas/inventory/tables/items/table
-- made with <3 @ constructive.io

-- requires: schemas/inventory/schema
-- requires: schemas/inventory/tables/warehouses/table


CREATE TABLE inventory.items (
  id serial,
  sku text NOT NULL,
  legacy_code text,
  PRIMARY KEY (id),
  CONSTRAINT items_sku_key 
    UNIQUE (sku),
  warehouse_id int REFERENCES inventory.warehouses (id)
);

ALTER TABLE inventory.items 
  DROP COLUMN legacy_code RESTRICT;

