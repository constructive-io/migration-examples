-- Revert: schemas/shop/tables/customers/columns/full_name/column


ALTER TABLE shop.customers 
  DROP COLUMN full_name RESTRICT;


