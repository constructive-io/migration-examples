-- Revert: schemas/shop/tables/customers/columns/id/column


ALTER TABLE shop.customers 
  DROP COLUMN id RESTRICT;


