-- Revert: schemas/shop/tables/customers/columns/created_at/column


ALTER TABLE shop.customers 
  DROP COLUMN created_at RESTRICT;


