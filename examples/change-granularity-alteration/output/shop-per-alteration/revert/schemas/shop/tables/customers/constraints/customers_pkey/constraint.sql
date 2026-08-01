-- Revert: schemas/shop/tables/customers/constraints/customers_pkey/constraint


ALTER TABLE ONLY shop.customers 
  DROP CONSTRAINT customers_pkey RESTRICT;


