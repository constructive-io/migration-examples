-- Revert: schemas/inventory/tables/items/table


-- revert not derivable: ALTER TABLE inventory.items AT_DropColumn (prior state unknown)

DROP TABLE inventory.items;


