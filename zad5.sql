-- Dodanie rozszerzenia PostGIS
CREATE EXTENSION postgis;

-- 1. Tworzenie tabeli `obiekty`
CREATE TABLE obiekty (
    id SERIAL PRIMARY KEY,
    nazwa TEXT NOT NULL,
    geometria GEOMETRY
);

-- a) Dodanie pierwszego obiektu jako COMPOUNDCURVE
INSERT INTO obiekty (nazwa, geometria) 
VALUES (
    'obiekt1',
    ST_GeomFromText('COMPOUNDCURVE(
        (0 1, 1 1), 
        CIRCULARSTRING(1 1, 2 0, 3 1),
        CIRCULARSTRING(3 1, 4 2, 5 1),
        (5 1, 6 1)
    )')
);

-- b) Wstawienie GEOMETRYCOLLECTION dla drugiego obiektu
INSERT INTO obiekty (nazwa, geometria) 
VALUES (
    'obiekt2',
    ST_GeomFromText('GEOMETRYCOLLECTION(
        COMPOUNDCURVE(
            (10 6, 14 6), 
            CIRCULARSTRING(14 6, 16 4, 14 2),
            CIRCULARSTRING(14 2, 12 0, 10 2),
            (10 2, 10 6)
        ),
        CIRCULARSTRING(
            11 2, 13 2, 11 2
        )
    )')
);

-- c) Dodanie trzeciego obiektu w postaci POLYGON
INSERT INTO obiekty (nazwa, geometria) 
VALUES (
    'obiekt3',
    ST_GeomFromText('POLYGON((10 17, 12 13, 7 15, 10 17))')
);

-- d) Dodanie czwartkowego obiektu jako LINESTRING
INSERT INTO obiekty (nazwa, geometria) 
VALUES (
    'obiekt4',
    ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)')
);

-- e) Wstawienie obiektu zawierającego GEOMETRYCOLLECTION z punktami 3D
INSERT INTO obiekty (nazwa, geometria) 
VALUES (
    'obiekt5',
    ST_GeomFromText('GEOMETRYCOLLECTION(
        POINTZ(30 30 59),
        POINTZ(38 32 234))')
);

-- f) Dodanie szóstego obiektu jako GEOMETRYCOLLECTION z linią i punktem
INSERT INTO obiekty (nazwa, geometria) 
VALUES (
    'obiekt6',
    ST_GeomFromText('GEOMETRYCOLLECTION(
        LINESTRING(1 1, 3 2),
        POINT(4 2)
    )')
);

-- 2. Obliczanie powierzchni bufora najkrótszej linii między `obiekt3` a `obiekt4`
SELECT ST_Area(ST_Buffer(shortest_line, 5)) AS area
FROM (
    SELECT ST_ShortestLine(ob3.geometria, ob4.geometria) AS shortest_line
    FROM obiekty ob3, obiekty ob4
    WHERE ob3.nazwa = 'obiekt3' AND ob4.nazwa = 'obiekt4'
) AS result;

-- 3. Aktualizacja `obiekt4` - przekształcenie linii na zamknięty POLYGON
UPDATE obiekty
SET geometria = ST_MakePolygon(ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5, 20 20)'))
WHERE nazwa = 'obiekt4';

-- 4. Tworzenie nowego obiektu `obiekt7` poprzez złączenie `obiekt3` i `obiekt4`
INSERT INTO obiekty (nazwa, geometria)
SELECT 'obiekt7', ST_Union(ob3.geometria, ob4.geometria)
FROM obiekty ob3, obiekty ob4
WHERE ob3.nazwa = 'obiekt3' AND ob4.nazwa = 'obiekt4';

-- 5. Sumowanie powierzchni buforów wszystkich obiektów, wykluczając typ ST_CircularString
SELECT SUM(ST_Area(ST_Buffer(geometria, 5))) AS total_area
FROM (
    SELECT *
    FROM obiekty
    WHERE ST_GeometryType(geometria) NOT IN ('ST_CircularString')
) AS filtered_geometries;
