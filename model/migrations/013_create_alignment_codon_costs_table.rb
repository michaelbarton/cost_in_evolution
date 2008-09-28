class CreateAlignmentCodonCostsTable < ActiveRecord::Migration

  def self.up
    create_table :alignment_codon_costs do |t|
      t.integer :alignment_codon_id
      t.integer :condition_id
      t.integer :cost_type_id
      t.float   :mean
    end
    add_index(:alignment_codon_costs,[:alignment_codon_id,:condition_id,:cost_type_id], 
      :unique => true, :name => :alignment_codon_cost_index)
  end

  def self.down
    drop_table :alignment_codon_costs
  end

end
