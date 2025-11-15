-- Create the database schema for the computers database
-- This matches the schema used in computers.php and process.php

-- Product table: maker, model, type
CREATE TABLE IF NOT EXISTS Product (
    maker TEXT NOT NULL,
    model INTEGER PRIMARY KEY,
    type TEXT NOT NULL
);

-- PC table: model, speed, ram, hd, price
CREATE TABLE IF NOT EXISTS PC (
    model INTEGER PRIMARY KEY,
    speed REAL,
    ram INTEGER,
    hd INTEGER,
    price REAL
);

-- Laptop table: model, speed, ram, hd, screen, price
CREATE TABLE IF NOT EXISTS Laptop (
    model INTEGER PRIMARY KEY,
    speed REAL,
    ram INTEGER,
    hd INTEGER,
    screen REAL,
    price REAL
);

-- Printer table: model, color, type, price
CREATE TABLE IF NOT EXISTS Printer (
    model INTEGER PRIMARY KEY,
    color TEXT,
    type TEXT,
    price REAL
);

-- Insert sample data into Product table
INSERT INTO Product (maker, model, type) VALUES
    ('A', 1001, 'PC'),
    ('A', 1002, 'PC'),
    ('A', 1003, 'PC'),
    ('A', 2004, 'Laptop'),
    ('A', 2005, 'Laptop'),
    ('A', 3006, 'Printer'),
    ('B', 1007, 'PC'),
    ('B', 1008, 'PC'),
    ('B', 2009, 'Laptop'),
    ('B', 2010, 'Laptop'),
    ('B', 3011, 'Printer'),
    ('C', 1012, 'PC'),
    ('C', 1013, 'PC'),
    ('C', 2014, 'Laptop'),
    ('C', 3015, 'Printer'),
    ('D', 1016, 'PC'),
    ('D', 2017, 'Laptop'),
    ('D', 2018, 'Laptop'),
    ('D', 3019, 'Printer'),
    ('E', 1020, 'PC'),
    ('E', 2021, 'Laptop'),
    ('E', 3022, 'Printer');

-- Insert sample data into PC table
INSERT INTO PC (model, speed, ram, hd, price) VALUES
    (1001, 2.66, 1024, 250, 2114),
    (1002, 2.10, 512, 250, 995),
    (1003, 1.42, 512, 80, 478),
    (1007, 2.80, 1024, 250, 649),
    (1008, 2.80, 2048, 300, 749),
    (1012, 2.20, 2048, 250, 1249),
    (1013, 2.20, 1024, 200, 1049),
    (1016, 2.20, 2048, 160, 999),
    (1020, 1.86, 2048, 160, 649);

-- Insert sample data into Laptop table
INSERT INTO Laptop (model, speed, ram, hd, screen, price) VALUES
    (2004, 2.00, 2048, 240, 20.1, 3673),
    (2005, 1.73, 1024, 80, 17.0, 949),
    (2009, 1.60, 512, 60, 15.4, 549),
    (2010, 2.00, 2048, 250, 15.4, 1150),
    (2014, 2.00, 1024, 120, 14.1, 898),
    (2017, 1.83, 1024, 120, 13.3, 549),
    (2018, 1.60, 512, 60, 15.4, 549),
    (2021, 1.87, 2048, 250, 14.1, 1399);

-- Insert sample data into Printer table
INSERT INTO Printer (model, color, type, price) VALUES
    (3006, 'true', 'ink-jet', 99),
    (3011, 'true', 'ink-jet', 270),
    (3015, 'false', 'laser', 399),
    (3019, 'true', 'ink-jet', 79),
    (3022, 'true', 'laser', 199);








