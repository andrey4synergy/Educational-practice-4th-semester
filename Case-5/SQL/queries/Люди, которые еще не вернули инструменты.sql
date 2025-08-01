SELECT 
    p.id AS person_id,
    p.name AS person_name,
    p.phone AS person_phone,
    i.id AS item_id,
    i.name AS item_name,
    i.description AS item_description,
    pl.begin_at AS taken_date,
    s.name AS storage_location,
    julianday('now') - julianday(pl.begin_at) AS days_held
FROM 
    Placement pl
JOIN 
    Person p ON pl.person_id = p.id
JOIN 
    Item i ON pl.item_id = i.id
LEFT JOIN 
    Storage s ON pl.storage_id = s.id
WHERE 
    pl.end_at IS NULL  -- Инструмент еще не возвращен
ORDER BY 
    days_held DESC;    -- Сначала те, кто держит дольше всего