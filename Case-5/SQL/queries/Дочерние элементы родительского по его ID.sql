-- Дочерние элементы родительского по его ID
SELECT
	child.id,
	child.code,
	child.name
FROM 
    ReferenceType child
LEFT JOIN 
    ReferenceType parent ON child.parent_id = parent.id
WHERE 
    child.parent_id = 1 -- родитель
ORDER BY 
    child.name;