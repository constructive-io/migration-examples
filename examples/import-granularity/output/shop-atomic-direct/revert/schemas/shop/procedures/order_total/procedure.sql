-- Revert: schemas/shop/procedures/order_total/procedure


COMMENT ON FUNCTION shop.order_total(p_order_id uuid) IS NULL;

DROP FUNCTION shop.order_total(uuid);


