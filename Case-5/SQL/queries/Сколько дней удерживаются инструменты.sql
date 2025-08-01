SELECT 
    p.name,
    i.name,
    pl.begin_at,
    julianday('now') - julianday(pl.begin_at) AS days_held
FROM Placement pl
JOIN Person p ON pl.person_id = p.id
JOIN Item i ON pl.item_id = i.id
WHERE pl.end_at IS NULL;