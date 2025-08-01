SELECT 
    p.name AS person_name,
    p.phone AS person_phone,
    i.name AS item_name,
    pl.begin_at AS taken_date,
    pl.end_at AS returned_date,
    CASE 
        WHEN pl.end_at IS NULL THEN 'Взято (еще не возвращено)'
        ELSE 'Возвращено'
    END AS status
FROM 
    Placement pl
JOIN 
    Person p ON pl.person_id = p.id
JOIN 
    Item i ON pl.item_id = i.id
WHERE 
    i.id = 2  -- Ищем только инструмент с ID = 1
ORDER BY 
    pl.begin_at DESC;