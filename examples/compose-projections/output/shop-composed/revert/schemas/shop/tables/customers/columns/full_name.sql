-- Revert: schemas/shop/tables/customers/columns/full_name


ALTER TABLE shop.customers 
  DROP COLUMN full_name RESTRICT;


