-- 1. Название и продолжительность самого длительного трека
SELECT title, duration
FROM track
ORDER BY duration DESC
LIMIT 1;

-- 2. Название треков, продолжительность которых не менее 3,5 минут
SELECT title
FROM track
WHERE duration >= 210;

-- 3. Названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT name
FROM collection
WHERE release_year BETWEEN 2018 AND 2020;

-- 4. Исполнители, чьё имя состоит из одного слова
SELECT name
FROM artist
WHERE name NOT LIKE '% %';

-- 5. Название треков, которые содержат слово «мой» или «my»
SELECT title
FROM track
WHERE 
    title ~* '\mмой\M' OR  
    title ~* '\mmy\M';     

-- 6. Количество исполнителей в каждом жанре
SELECT g.name AS genre, COUNT(ag.artistid) AS artist_count
FROM genre g
JOIN artist_genres ag ON g.genreid = ag.genreid
GROUP BY g.name;

-- 7. Количество треков, вошедших в альбомы 2019–2020 годов
SELECT COUNT(t.trackid) AS track_count
FROM track t
JOIN album a ON t.albumid = a.albumid
WHERE a.release_year BETWEEN 2019 AND 2020;

-- 8. Средняя продолжительность треков по каждому альбому
SELECT a.title AS album_name, ROUND(AVG(t.duration), 2) AS avg_duration
FROM album a
JOIN track t ON a.albumid = t.albumid
GROUP BY a.title;

-- 9. Все исполнители, которые не выпустили альбомы в 2020 году
SELECT DISTINCT ar.name
FROM artist ar
WHERE ar.artistid NOT IN (
    SELECT aa.artistid
    FROM album_artist aa
    JOIN album a ON aa.albumid = a.albumid
    WHERE a.release_year = 2020
);

-- 10. Названия сборников, в которых присутствует конкретный исполнитель
SELECT DISTINCT c.name
FROM collection c
JOIN track_collection ct ON c.collectionid = ct.collectionid
JOIN track t ON ct.trackid = t.trackid
JOIN album a ON t.albumid = a.albumid
JOIN album_artist aa ON a.albumid = aa.albumid
JOIN artist ar ON aa.artistid = ar.artistid
WHERE ar.name = 'Leningrad';