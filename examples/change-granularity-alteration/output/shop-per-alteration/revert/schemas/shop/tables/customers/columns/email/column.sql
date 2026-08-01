-- Revert: schemas/shop/tables/customers/columns/email/column


ALTER TABLE shop.customers 
  DROP COLUMN email RESTRICT;


