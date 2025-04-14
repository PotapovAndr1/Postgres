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
