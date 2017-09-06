require_relative './lib/associatable'

class Artist < SQLObject
  has_many :albums,
    class_name: :Album

  has_many_through :songs, :albums, :songs

  finalize!
end

class Album < SQLObject
  has_many :songs,
    class_name: :Song

  belongs_to :artist,
    class_name: :artist

  finalize!
end

class Song < SQLObject
  belongs_to :album,
    class_name: :Album

  has_one_through :artist, :album, :artist

  finalize!
end
