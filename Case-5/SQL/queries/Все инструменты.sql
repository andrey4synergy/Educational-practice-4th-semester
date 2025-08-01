-- Все инструменты в месте хранения
SELECT i.id, i.name, s.name as storage
FROM Item i
LEFT JOIN Storage s ON i.storage_id = s.id;

SELECT * FROM Item;