require_relative 'searchable'
require 'active_support/inflector'
require 'byebug'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.to_s.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    default = {
      primary_key: :id,
      foreign_key: "#{name}_id".to_sym,
      class_name: name.to_s.camelcase
    }

    default.keys.each do |k|
      self.send("#{k}=", options[k] || default[k])
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    default = {
      primary_key: :id,
      foreign_key: "#{self_class_name}_id".downcase.to_sym,
      class_name: name.to_s.singularize.camelcase
    }
    default.keys.each do |k|
      self.send("#{k}=", options[k] || default[k])
    end
  end
end

module Associatable
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)
    define_method(name) do
      options = self.class.assoc_options[name]
      target_class = options.model_class
      foreign_key = options.foreign_key
      primary_key = options.primary_key
      id = self.send(foreign_key)

      target_class.where(primary_key => id).first
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, self.name, options)
    define_method(name) do
      options = self.class.assoc_options[name]
      target_class = options.model_class
      foreign_key = options.foreign_key
      primary_key = options.primary_key
      id = self.send(primary_key)

      target_class.where(foreign_key => id)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.table_name
      through_prim = through_options.primary_key
      through_foreign = through_options.foreign_key

      source_table = source_options.table_name
      source_prim = source_options.primary_key
      source_foreign = source_options.foreign_key

      value = self.send(through_foreign)
      query = DBConnection.execute(<<-SQL, value)
      SELECT
        #{source_table}.*
      FROM
        #{through_table}
      JOIN
        #{source_table}
      ON
        #{source_table}.#{source_prim} = #{through_table}.#{source_foreign}
      WHERE
        #{through_table}.#{through_prim} = ?
      SQL
      source_options.model_class.parse_all(query).first
    end
  end

  def has_many_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.table_name
      through_prim = through_options.primary_key
      through_foreign = through_options.foreign_key

      source_table = source_options.table_name
      source_prim = source_options.primary_key
      source_foreign = source_options.foreign_key

      value = self.id
      query = DBConnection.execute(<<-SQL, value)
      SELECT
        #{source_table}.*
      FROM
        #{through_table}
      JOIN
        #{source_table}
      ON
        #{source_table}.#{source_foreign} = #{through_table}.#{source_prim}
      WHERE
        #{through_table}.#{through_foreign} = ?
      SQL
      source_options.model_class.parse_all(query)
    end
  end
end

class SQLObject
  extend Associatable
end
