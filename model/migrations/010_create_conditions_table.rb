class CreateConditionsTable < ActiveRecord::Migration

  def self.up
    create_table :conditions do |t|
      t.string  :abbrv, :limit => 4
      t.string  :name
    end
    add_index(:conditions, :abbrv, :unique => true)
  end

  def self.down
    drop_table :conditions
  end

end
