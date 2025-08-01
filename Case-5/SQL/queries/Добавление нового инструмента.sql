BEGIN TRANSACTION;

INSERT INTO Placement (item_id, person_id, begin_at, notes)
VALUES (1, 1, datetime('now', '-1 hour'), 'Тест взят');

ROLLBACK;