-- Revert: schemas/shop/tables/customers/columns/email


ALTER TABLE shop.customers 
  DROP COLUMN email RESTRICT;


