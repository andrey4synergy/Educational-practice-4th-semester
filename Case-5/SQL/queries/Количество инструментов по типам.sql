-- Количество инструментов по типам
SELECT item_type, SUM(quantity) AS total_quantity
FROM InventoryOnStorage
GROUP BY item_type;