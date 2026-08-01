-- Revert: schemas/shop/tables/customers/constraints/customers_pkey


ALTER TABLE ONLY shop.customers 
  DROP CONSTRAINT customers_pkey RESTRICT;


