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
(3, 'Chasiki', 2005);

-- Треки
INSERT INTO track (trackid, title, duration, albumid) VALUES
(1, 'WWW', 186, 1),
(2, 'Terminator', 177, 1),
(3, 'Tuchi', 295, 2),
(4, 'Topoliniy puh', 223, 2),
(5, 'Do skoroy vstrechi', 201, 3),
(6, 'Tramvai', 281, 3);

-- Сборники
INSERT INTO collection (collectionid, name, release_year) VALUES
(1, 'Greatest Hits 2000s', 2010),
(2, 'Hits 2000', 2016),
(3, 'Best Rock', 2019),
(4, 'Love Songs', 2015);

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
(4, 3);

-- Связь сборников с треками
INSERT INTO track_collection (collectionid, trackid) VALUES
(1, 1),
(1, 3),
(2, 2),
(2, 4),
(3, 1),
(3, 5),
(4, 4),
(4, 6);
