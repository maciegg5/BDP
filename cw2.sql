-- a)
SELECT SUM(ST_Length(geometry)) AS total_length FROM roads;

-- b)
SELECT 
    ST_AsText(geometry) AS wkt,
    ST_Area(geometry) AS area,
    ST_Perimeter(geometry) AS perimeter
FROM buildings
WHERE name = 'BuildingA';

-- c)
SELECT name, ST_Area(geometry) AS area
FROM buildings
ORDER BY name;

-- d)
SELECT name, ST_Perimeter(geometry) AS perimeter
FROM buildings
ORDER BY ST_Area(geometry) DESC
LIMIT 2;

-- e)
SELECT ST_Distance(b.geometry, ST_GeomFromText('POINT(10 10)', 4326)) AS distance
FROM buildings b
WHERE name = 'BuildingC';

-- f)
SELECT ST_Area(ST_Difference(c.geometry, ST_Buffer(b.geometry, 0.5))) AS area
FROM buildings c, buildings b
WHERE c.name = 'BuildingC' AND b.name = 'BuildingB';

-- g)
SELECT b.name
FROM buildings b, roads r
WHERE r.name = 'RoadX' AND ST_Y(ST_Centroid(b.geometry)) > ST_Y(r.geometry);

-- h)
SELECT 
    ST_Area(ST_SymDifference(c.geometry, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))', 4326))) AS area
FROM buildings c
WHERE c.name = 'BuildingC';
