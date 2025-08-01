-- Одновременное добавление инструмента прямо в хранилище
-- например, в случае покупки

BEGIN TRANSACTION;

INSERT INTO Item (item_type_id, name, description, quantity, storage_id)
VALUES (
    (SELECT id FROM ReferenceType WHERE name LIKE '%Шуруповерт%' LIMIT 1),
    'Шуруповерт DeWalt DCF887',
    'Аккумуляторный, 18V, с быстрозажимным патроном',
    1,
    3  -- ID места хранения "Основной склад"
);

INSERT INTO Placement (item_id, storage_id, begin_at, notes)
VALUES (
    last_insert_rowid(),
    3,
    CURRENT_TIMESTAMP,
    'Первоначальное размещение на основном складе'
);

COMMIT;