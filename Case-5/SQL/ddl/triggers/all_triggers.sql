-- триггер, который предотвращает добавление дублирующих перемещений инструментов 
-- (когда инструмент уже находится в указанном месте хранения или у того же человека
CREATE TRIGGER prevent_duplicate_placement
BEFORE INSERT ON Placement
FOR EACH ROW
WHEN (
    -- Проверяем, что существует активное размещение с такими же параметрами
    EXISTS (
        SELECT 1 FROM Placement
        WHERE item_id = NEW.item_id
        AND end_at IS NULL  -- Только активные размещения
        AND (
            -- Проверка на дублирование места хранения
            (NEW.storage_id IS NOT NULL AND storage_id = NEW.storage_id)
            OR
            -- Проверка на дублирование человека
            (NEW.person_id IS NOT NULL AND person_id = NEW.person_id)
        )
    )
)
BEGIN
    SELECT RAISE(ABORT, 'Дублирующее перемещение: инструмент уже находится в указанном месте/у указанного человека');
END;


-- Триггер для проверки корректности перемещения (либо место хранения, либо человек)
CREATE TRIGGER validate_placement
BEFORE INSERT ON Placement
FOR EACH ROW
WHEN (NEW.storage_id IS NOT NULL AND NEW.person_id IS NOT NULL)
BEGIN
    SELECT RAISE(ABORT, 'Инструмент не может одновременно находиться и в месте хранения, и у человека');
END;


-- Триггер для автоматического обновления storage_id в таблице Item
CREATE TRIGGER update_item_storage
AFTER INSERT ON Placement
FOR EACH ROW
WHEN NEW.storage_id IS NOT NULL AND NEW.end_at IS NULL
BEGIN
    UPDATE Item SET storage_id = NEW.storage_id WHERE id = NEW.item_id;
END;



-- Триггер для очистки storage_id при выдаче инструмента человеку
CREATE TRIGGER clear_storage_when_taken
AFTER INSERT ON Placement
FOR EACH ROW
WHEN NEW.person_id IS NOT NULL AND NEW.end_at IS NULL
BEGIN
    UPDATE Item SET storage_id = NULL WHERE id = NEW.item_id;
END;