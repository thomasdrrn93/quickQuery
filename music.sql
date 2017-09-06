  CREATE TABLE songs (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    album_id INTEGER,

    FOREIGN KEY(album_id) REFERENCES album(id)
  );

  CREATE TABLE albums (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    artist_id INTEGER,

    FOREIGN KEY(artist_id) REFERENCES album(id)
  );

  CREATE TABLE artists (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL
  );


  INSERT INTO
    artists (id, name)
  VALUES
    (1, "Radiohead"), (2, "Chance the Rapper");

  INSERT INTO
    albums (id, name, artist_id)
  VALUES
    (1, "Ok Computer", 1),
    (2, "Kid A", 1),
    (3, "Acid Rap", 2),
    (4, "Coloring Book", 2);

  INSERT INTO
    songs (id, name, album_id)
  VALUES
    (1, "Karma Police", 1),
    (2, "The National Anthem", 2),
    (3, "Juice", 3),
    (4, "Pusha Man", 3),
    (5, "No album", NULL);
