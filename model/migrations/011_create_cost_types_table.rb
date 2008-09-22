class CreateCostTypesTable < ActiveRecord::Migration

  def self.up
    create_table :cost_types do |t|
      t.string  :abbrv, :limit => 4
      t.string  :name
    end
    add_index(:cost_types, :abbrv, :unique => true)
  end

  def self.down
    drop_table :cost_types
  end

end
