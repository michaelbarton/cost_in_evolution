class CreateAminoAcidCostsTable < ActiveRecord::Migration

  def self.up
    create_table :amino_acid_costs do |t|
      t.integer :amino_acid_id
      t.integer :condition_id
      t.integer :cost_type_id
      t.float   :estimate
    end
    add_index(:amino_acid_costs,[:amino_acid_id,:condition_id,:cost_type_id], 
      :unique => true, :name => :amino_acid_cost_index)
  end

  def self.down
    drop_table :amino_acid_costs
  end

end
