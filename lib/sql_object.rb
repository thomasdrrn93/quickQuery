require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    return @cols if @cols
    info = DBConnection.execute2 (<<-SQL)
    SELECT
      *
    FROM
      '#{table_name}'
    SQL
    @cols = info.first.map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |key|
      define_method(key) do
        self.attributes[key]
      end
      define_method("#{key}=") do |val|
        self.attributes[key] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.name.tableize
  end

  def self.all
  results =  DBConnection.execute(<<-SQL)
    SELECT
      #{table_name}.*
    FROM
      #{table_name}
    SQL

    self.parse_all(results)
  end

  def self.parse_all(results)
    objects = results.map do |hash|
      self.new(hash)
    end
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL, id)
    SELECT
      #{table_name}.*
    FROM
      #{table_name}
    WHERE
      #{table_name}.id = ?
    SQL
    self.parse_all(results).first
  end

  def initialize(params = {})
    params.each do |name, value|
      name = name.to_sym
      unless self.class.columns.include?(name)
        raise  "unknown attribute '#{name}'"
      end
      self.send("#{name}=", value)
    end
  end

  def attributes
    if @attributes
      @attributes
    else
      @attributes = {}
    end
  end

  def attribute_values
    cols = self.class.columns
    cols.map do |col|
      self.send(col)
    end
  end

  def insert
    col_names = self.class.columns.drop(1).map(&:to_sym).join(", ")
    question_marks = ["?"] * ((self.class.columns.length) - 1)
    DBConnection.execute(<<-SQL, *self.attribute_values.drop(1))
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{question_marks.join(", ")})
    SQL
    self.attributes[:id] = DBConnection.last_insert_row_id
  end

  def update
    cols = self.class.columns.map(&:to_sym)
    set_cols = cols.map { |col| "#{col}= ?" }
    DBConnection.execute(<<-SQL, *self.attribute_values, self.attributes[:id])
    UPDATE
      #{self.class.table_name}
    SET
      #{set_cols.join(", ")}
    WHERE
      id = ?
    SQL
  end

  def save
    if self.attributes[:id].nil?
      insert
    else
      update
    end
  end
end
