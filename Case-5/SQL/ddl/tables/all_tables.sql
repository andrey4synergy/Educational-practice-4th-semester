-- Item определение

CREATE TABLE Item (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_type_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity >= 1),
    storage_id INTEGER,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (storage_id) REFERENCES Storage(id) ON DELETE SET NULL,
    FOREIGN KEY (item_type_id) REFERENCES ReferenceType(id) ON DELETE RESTRICT
);

-- Person определение

CREATE TABLE Person (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    phone TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Placement определение

CREATE TABLE Placement (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_id INTEGER NOT NULL,
    person_id INTEGER,  -- Кто совершил действие (может быть NULL для системных перемещений)
    storage_id INTEGER, -- Перемещение между местами хранения
    begin_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    end_at DATETIME, -- Дата завершения может быть открытой (пустой)
    notes TEXT,
    FOREIGN KEY (item_id) REFERENCES Item(id) ON DELETE CASCADE,
    FOREIGN KEY (person_id) REFERENCES Person(id) ON DELETE SET NULL
);

-- ReferenceKind определение

CREATE TABLE ReferenceKind (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	code TEXT NOT NULL UNIQUE,
	description TEXT
);

-- ReferenceType определение

CREATE TABLE ReferenceType (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    parent_id INTEGER,
    kind_id INTEGER,
    name TEXT NOT NULL,
    code TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES ReferenceType(id) ON DELETE CASCADE
    FOREIGN KEY (kind_id) REFERENCES ReferenceKind(id) ON DELETE CASCADE
);

-- Storage определение

CREATE TABLE Storage (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    parent_id INTEGER,
    storage_type_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES Storage(id) ON DELETE CASCADE,
    FOREIGN KEY (storage_type_id) REFERENCES ReferenceType(id) ON DELETE RESTRICT
);
