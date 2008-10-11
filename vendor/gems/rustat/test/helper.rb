require 'rubygems'
require 'spec'
require 'active_record'

$:.unshift File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + '/../init'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
 
def setup_db
  ActiveRecord::Migration.verbose = false
  ActiveRecord::Schema.define(:version => 1) do
    create_table :people do |t|
      t.integer :age
    end
  end
end
 
def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Person < ActiveRecord::Base
end
