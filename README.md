# quickQuery

quickQuery is a Ruby object-relational mapping framework inspired by Rails' ActiveRecord. quickQuery builds associations between models in and allows user to quickly and effortlessly query the database for relevant relational information.

## Getting Started

After cloning this repo, open up pry in your terminal. In pry type load 'sample.rb'. This file sets up three models (Artist, Album, and Song). The database has already been seeded with data. After loading the file, test out the database querying and association methods.

### Test

Test the find method by typing Album.find(1) in the terminal. It should return the following.
![pic](/assets/albumfind.png)

Test the all method by typing Artist.all in the terminal. It should return the following.
![pic](/assets/artistall.png)

Test the has many association by typing Album.find(3).songs in the terminal. It should return the following.
![pic](/assets/hasmany.png)

Test the has many through association by typing Artist.first.songs in the terminal. It should return the following.
![pic](/assets/hasmanythrough.png)     

Test the has one through association by typing Song.find(1).artist in the terminal. It should return the following.
![pic](/assets/hasonethrough.png)

### Methods

#### ::columns
  Returns an array of columns in a particular model's table.

#### ::where(params)
  Returns an array of instances of class that match given params.

#### ::find(id)
  Returns the instance of a class that matches the given id.

#### ::table_name
  Returns an instance variable of a model's table name or creates a table name for the model.

#### ::table_name=
  Sets a table name equal to the argument.

#### ::all
  Returns an array of all instances that belong to a class.

#### ::first
  Returns the first instance of a particular class.

#### ::last
  Returns the last instance of a particular class.

#### insert
  Inserts a new object into the table.

#### update
  Updates attributes of an existing object in the database.

#### save
  Saves new or updated object into the database.

#### #initialize(params)

Creates a new instance of class using given params. Params are key-value pairs where the keys are specific columns names in a table and the values are values for those columns.

#### belongs_to(name, options)

Creates a one to one relationship between two models. The associated model is returned after calling this method.     

#### has_many(name, options)

Creates a one to many relationship between two models. The associated model is returned after calling this method.

#### has_one_through(name, through_name, source_name)

Creates a one to one relationship between two models. This relationship is made by using an existing relationship that the two models share. The associated model is returned after calling this method.

#### has_many_through(name, through_name, source_name)

Creates a one to many relationship between two models. This relationship is made by using an existing relationship that the two models share. The associated model is returned after calling this method.
