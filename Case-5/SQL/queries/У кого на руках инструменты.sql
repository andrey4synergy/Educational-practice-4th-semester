SELECT p.name AS person, i.name AS item, 
       CASE WHEN pl.storage_id IS NULL THEN 'У человека' ELSE s.name END AS location,
       pl.begin_at AS since
FROM Placement pl
JOIN Item i ON pl.item_id = i.id
LEFT JOIN Person p ON pl.person_id = p.id
LEFT JOIN Storage s ON pl.storage_id = s.id
WHERE pl.end_at IS NULL AND pl.person_id IS NOT NULL;


