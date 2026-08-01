-- Revert: schemas/shop/tables/orders/table/alter


ALTER TABLE shop.orders DROP CONSTRAINT orders_status_check RESTRICT;
ALTER TABLE shop.orders ADD CONSTRAINT orders_status_check CHECK (status IN ('pending', 'paid', 'shipped', 'cancelled'));


