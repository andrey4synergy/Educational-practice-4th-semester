-- Отображение инструментов на складе с указанием мест хранения
CREATE VIEW InventoryOnStorage AS
SELECT 
    i.id AS item_id,
    i.name AS item_name,
    rt.name AS item_type,
    i.description,
    i.quantity,
    s.id AS storage_id,
    s.name AS storage_name,
    s.description AS storage_description,
    st.name AS storage_type,
    i.created_at AS item_added_date,
    i.updated_at AS item_last_updated
FROM 
    Item i
JOIN 
    ReferenceType rt ON i.item_type_id = rt.id
JOIN 
    Storage s ON i.storage_id = s.id
JOIN 
    ReferenceType st ON s.storage_type_id = st.id
WHERE 
    i.storage_id IS NOT NULL
ORDER BY 
    s.name, rt.name, i.name;


-- Вариант с дополнительной информацией о последнем перемещении
CREATE VIEW DetailedInventoryOnStorage AS
SELECT 
    i.id AS item_id,
    i.name AS item_name,
    rt.name AS item_type,
    i.quantity,
    s.id AS storage_id,
    s.name AS storage_location,
    st.name AS storage_type,
    (SELECT MAX(begin_at) FROM Placement WHERE item_id = i.id AND storage_id = s.id) AS last_placed_date,
    (SELECT name FROM Person p 
     JOIN Placement pl ON p.id = pl.person_id 
     WHERE pl.item_id = i.id 
     ORDER BY pl.begin_at DESC LIMIT 1) AS last_handled_by,
    i.updated_at AS last_updated
FROM 
    Item i
JOIN 
    ReferenceType rt ON i.item_type_id = rt.id
JOIN 
    Storage s ON i.storage_id = s.id
JOIN 
    ReferenceType st ON s.storage_type_id = st.id
WHERE 
    i.storage_id IS NOT NULL
ORDER BY 
    storage_location, item_type, item_name;