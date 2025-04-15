-- Таблица исполнителей
CREATE TABLE artist (
    artistid SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Таблица жанров
CREATE TABLE genre (
    genreid SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Связь "исполнитель-жанр" (многие-ко-многим)
CREATE TABLE artist_genres (
    artistid INT,
    genreid INT,
    PRIMARY KEY (artistid, genreid),
    FOREIGN KEY (artistid) REFERENCES artist(artistid) ON DELETE CASCADE,
    FOREIGN KEY (genreid) REFERENCES genre(genreid) ON DELETE CASCADE
);

-- Таблица альбомов
CREATE TABLE album (
    albumid SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year SMALLINT
);

-- Связь "альбом-исполнитель" (многие-ко-многим)
CREATE TABLE album_artist (
    albumid INT,
    artistid INT,
    PRIMARY KEY (albumid, artistid),
    FOREIGN KEY (albumid) REFERENCES album(albumid) ON DELETE CASCADE,
    FOREIGN KEY (artistid) REFERENCES artist(artistid) ON DELETE CASCADE
);

-- Таблица треков
CREATE TABLE track (
    trackid SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    duration INT, 
    albumid INT,
    FOREIGN KEY (albumid) REFERENCES album(albumid) ON DELETE CASCADE
);

-- Таблица сборников
CREATE TABLE collection (
    collectionid SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    release_year SMALLINT NOT NULL
);

-- Связь "трек-сборник" (многие-ко-многим)
CREATE TABLE track_collection (
    trackid INT,
    collectionid INT,
    PRIMARY KEY (trackid, collectionid),
    FOREIGN KEY (trackid) REFERENCES track(trackid) ON DELETE CASCADE,
    FOREIGN KEY (collectionid) REFERENCES collection(collectionid) ON DELETE CASCADE
);


-- Исполнители
INSERT INTO artist (artistid, name) VALUES
(1, 'Leningrad'),
(2, 'Ivanushki int'),
(3, 'Zveri'),
(4, 'Valeria');

-- Жанры
INSERT INTO genre (genreid, name) VALUES
(1, 'Pop'),
(2, 'Rock'),
(3, 'Alternative');

-- Альбомы
INSERT INTO album (albumid, title, release_year) VALUES
(1, 'WWW', 2008),
(2, 'Tuchi', 2000),
(3, 'Chasiki', 2005),
(4, 'New', 2020);

-- Связь исполнителей с жанрами
INSERT INTO artist_genres (artistid, genreid) VALUES
(1, 2), 
(1, 3),  
(2, 1),  
(3, 2), 
(4, 1); 

-- Связь исполнителей с альбомами
INSERT INTO album_artist (artistid, albumid) VALUES
(1, 1),
(2, 2),
(4, 3),
(3, 4);

-- Треки
INSERT INTO track (trackid, title, duration, albumid) VALUES
(1, 'WWW', 186, 1),
(2, 'Terminator', 177, 1),
(3, 'Tuchi', 295, 2),
(4, 'Topoliniy puh', 223, 2),
(5, 'Do skoroy vstrechi', 201, 3),
(6, 'Tramvai', 281, 3),
(7, 'My mir', 225, 4),
(8, 'Nova Era', 240, 4),
(9, 'Start Again', 210, 4);

-- Сборники
INSERT INTO collection (collectionid, name, release_year) VALUES
(1, 'Greatest Hits 2000s', 2010),
(2, 'Hits 2000', 2016),
(3, 'Best Rock', 2019),
(4, 'Love Songs', 2015);

-- Связь сборников с треками
INSERT INTO track_collection (collectionid, trackid) VALUES
(1, 1),
(1, 3),
(2, 2),
(2, 4),
(3, 1),
(3, 5),
(4, 4),
(4, 6),
(3, 7),
(4, 8),
(3, 9);

-- 1. Название и продолжительность самого длительного трека
SELECT title, duration
FROM track
ORDER BY duration DESC
LIMIT 1;

-- 2. Название треков, продолжительность которых не менее 3,5 минут (210 секунд)
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