-- Revert: schemas/shop/tables/order_items/table


REVOKE SELECT, INSERT ON shop.order_items FROM app_user RESTRICT;

DROP TABLE shop.order_items;


