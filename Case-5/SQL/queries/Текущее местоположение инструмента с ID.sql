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
    i.id = 1;