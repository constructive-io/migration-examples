-- Revert: schemas/shop/tables/customers/columns/id


ALTER TABLE shop.customers 
  DROP COLUMN id RESTRICT;


