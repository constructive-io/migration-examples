-- Revert: schemas/shop/tables/customers/columns/phone


ALTER TABLE shop.customers 
  DROP COLUMN phone RESTRICT;


