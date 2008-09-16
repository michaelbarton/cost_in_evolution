class CreateAminoAcidCostsTable < ActiveRecord::Migration

  def self.up
    create_table :amino_acid_costs do |t|
      t.integer :amino_acid_id
      t.string  :name
      t.float   :estimate
    end
    add_index(:amino_acid_costs,:amino_acid_id)
    add_index(:amino_acid_costs,[:amino_acid_id,:name], :unique => true)
  end

  def self.down
    drop_table :amino_acid_costs
  end

end
