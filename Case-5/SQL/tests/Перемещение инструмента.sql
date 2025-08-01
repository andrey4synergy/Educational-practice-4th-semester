-- Разместить инструмент в новое место

SAVEPOINT test_insert;

-- Тестируемый запрос
-- 1. Закрываем текущее активное размещение (если есть)
UPDATE Placement 
SET end_at = CURRENT_TIMESTAMP,
    notes = 'Перемещение'
WHERE item_id = 29 -- Перфоратор
  AND end_at IS NULL;

-- 2. Создаем запись о новом размещении
INSERT INTO Placement (item_id, person_id, storage_id, begin_at, notes)
VALUES (
    29, -- Перфоратор
    15,  -- Иванов
    17, -- Цех №1
    CURRENT_TIMESTAMP,
    'Перемещение'
);

-- 3. Обновляем текущее местоположение инструмента
UPDATE Item
SET storage_id = 17 -- Цех №1
WHERE id = 29;

-- Проверка

SELECT 
    i.name AS инструмент,
    s.name AS место_хранения,
    p.name AS разместивший_сотрудник,
    pl.begin_at AS дата_размещения,
    pl.notes
FROM Item i
JOIN Placement pl ON i.id = pl.item_id
JOIN Storage s ON pl.storage_id = s.id
JOIN Person p ON pl.person_id = p.id;

ROLLBACK TO SAVEPOINT test_insert;

--SELECT * FROM Placement;

--DELETE FROM Placement;
