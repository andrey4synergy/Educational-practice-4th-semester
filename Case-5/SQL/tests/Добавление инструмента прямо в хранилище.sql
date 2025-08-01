-- Одновременное добавление инструмента прямо в хранилище
-- например, в случае покупки

SAVEPOINT test_insert;


-- 1. Добавляем инструмент в систему (без указания storage_id)
INSERT INTO Item (item_type_id, name, description, quantity)
VALUES (
    (SELECT id FROM ReferenceType WHERE name LIKE '%Шуруповерт%' LIMIT 1),
    'Шуруповерт DeWalt DCF887',
    'Аккумуляторный, 18V, с быстрозажимным патроном',
    1
);

-- 2. Фиксируем размещение с указанием сотрудника
INSERT INTO Placement (item_id, person_id, storage_id, begin_at, notes)
VALUES (
    last_insert_rowid(),  -- ID нового инструмента
    15,                   -- ID сотрудника, который размещает
    19,                   -- ID места хранения
    CURRENT_TIMESTAMP,
    'Первичное размещение'
);

-- 3. Обновляем текущее местоположение в таблице Item
UPDATE Item
SET storage_id = 15
WHERE id = last_insert_rowid();

-- Проверка

SELECT 
    i.id AS item_id,
    i.name AS item_name,
    s.id AS storage_id,
    s.name AS storage_name,
    s.description AS storage_description,
    CASE 
        WHEN pl.person_id IS NOT NULL THEN 'У человека на руках'
        WHEN pl.storage_id IS NOT NULL THEN 'В хранилище'
        ELSE 'Местоположение неизвестно'
    END AS location_status,
    p.name AS held_by_person,
    p.phone AS person_phone,
    pl.begin_at AS since_date,
    julianday('now') - julianday(pl.begin_at) AS days_in_location
FROM 
    Item i
LEFT JOIN 
    Placement pl ON i.id = pl.item_id AND pl.end_at IS NULL
LEFT JOIN 
    Storage s ON pl.storage_id = s.id
LEFT JOIN 
    Person p ON pl.person_id = p.id
WHERE 
    i.id = 29;


ROLLBACK TO SAVEPOINT test_insert;

--SELECT * FROM Placement;
--
--DELETE FROM Placement;
--
--SELECT * FROM Storage;
