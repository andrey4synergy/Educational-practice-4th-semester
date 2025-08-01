BEGIN TRANSACTION;

-- Сначала закрываем текущее активное размещение (если есть)
UPDATE Placement 
SET end_at = CURRENT_TIMESTAMP
WHERE item_id = 6 AND end_at IS NULL;

-- Затем создаем новое размещение в хранилище
INSERT INTO Placement (item_id, storage_id, begin_at)
VALUES (
    6,  -- ID инструмента
    1,  -- ID места хранения
    CURRENT_TIMESTAMP    
);

UPDATE Item
SET storage_id = 1  -- ID нового места хранения
WHERE id = 6;       -- ID инструмента

COMMIT;