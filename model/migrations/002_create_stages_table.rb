class CreateStagesTable < ActiveRecord::Migration

  def self.up
    create_table :stages do |t|
      t.integer :number
      t.text    :title
      t.text    :description
    end
  end

  def self.down
    drop_table :stages
  end

end
