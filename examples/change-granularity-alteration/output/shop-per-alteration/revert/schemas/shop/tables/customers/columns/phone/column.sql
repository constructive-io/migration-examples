-- Revert: schemas/shop/tables/customers/columns/phone/column


ALTER TABLE shop.customers 
  DROP COLUMN phone RESTRICT;


