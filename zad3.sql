--zad1
-- a) wybudowane
create table new_buildings as
select k2019.*
from karlsruhe_2019 k2019
left join karlsruhe_2018 k2018
on ST_Equals(k2019.geom, k2018.geom)
where k2018.geom is null;
--b) wyremontowane
create table renovated_buildings5 as
select k2019.*
from karlsruhe_2019 k2019
left join karlsruhe_2018 k2018
on k2019.polygon_id = k2018.polygon_id
where not ST_Equals(k2019.geom, k2018.geom) or
k2019.polygon_id is null or
k2019.height != k2018.height;
select * from renovated_buildings4;
--zad2
create table changed_buildings as
select * from new_buildings
union
select * from renovated_buildings4;
select * from changed_buildings;
create table new_pois as
select p2019.*
from poi_2019 p2019
left join poi_2018 p2018
on p2019.poi_id = p2018.poi_id
where p2018.poi_id is null;
select * from new_pois;

CREATE TABLE new_pois_near2 AS
SELECT DISTINCT 
    ch_b.polygon_id, 
    ch_b.name, 
    ch_b.geom AS chb, 
    n_p.poi_id
FROM changed_buildings ch_b
JOIN new_pois n_p
ON ST_DWithin(ch_b.geom, n_p.geom, 500);

select * from new_pois_near2;

select * from karlsruhe_2019;

--zad3
CREATE TABLE streets_reprojected AS
SELECT gid, link_id, st_name, ST_Transform(ST_SetSRID(geom, 4326), 31468) AS geom
FROM street_2019;
select * from streets_reprojected;

-- zad4
create table input_points(
id serial primary key,
geom GEOMETRY(Point, 4326));

insert into input_points (geom)
values
(ST_SetSRID(ST_MakePoint(8.36093, 49.03174), 4326)),
(ST_SetSRID(ST_MakePoint(8.39876, 49.00644), 4326));

select * from input_points_cassini;

-- zad5
create table input_points_cassini as
select id, ST_Transform(ST_SetSRID(geom, 4326), 31468) as geom
from input_points;

-- zad6
UPDATE input_points_cassini
SET geom = ST_Transform(geom, 4326)
WHERE ST_SRID(geom) != 4326;
SELECT sn_2019.*
FROM street_node_2019 sn_2019
JOIN input_points_cassini in_p
ON ST_DWithin(sn_2019.geom, in_p.geom, 200);

-- zad7
SELECT COUNT(*) AS sports_stores_near_parks
FROM poi_2019 p
JOIN land_use_a_2019 l
ON ST_DWithin(p.geom, l.geom, 300)
WHERE p.type = 'Sporting Goods Store';

-- zad8
CREATE TABLE T2019_KAR_BRIDGES AS
SELECT
    r.gid AS railway_gid,
    w.gid AS waterline_gid,
    ST_Intersection(r.geom, w.geom) AS geom
FROM railways_2019 r
JOIN lines_2019 w
ON ST_Intersects(r.geom, w.geom);
