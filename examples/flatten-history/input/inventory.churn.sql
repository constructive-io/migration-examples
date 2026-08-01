CREATE SCHEMA inventory;

CREATE TABLE inventory.warehouses (
);

ALTER TABLE inventory.warehouses ADD COLUMN id serial PRIMARY KEY;
ALTER TABLE inventory.warehouses ADD COLUMN name text;
ALTER TABLE inventory.warehouses ALTER COLUMN name SET NOT NULL;

CREATE TABLE inventory.items (
);

ALTER TABLE inventory.items ADD COLUMN id serial;
ALTER TABLE inventory.items ADD COLUMN sku text;
ALTER TABLE inventory.items ADD COLUMN legacy_code text;
ALTER TABLE inventory.items DROP COLUMN legacy_code;
ALTER TABLE inventory.items ALTER COLUMN sku SET NOT NULL;
ALTER TABLE inventory.items ADD PRIMARY KEY (id);
ALTER TABLE inventory.items ADD CONSTRAINT items_sku_key UNIQUE (sku);
ALTER TABLE inventory.items ADD COLUMN warehouse_id int REFERENCES inventory.warehouses(id);
