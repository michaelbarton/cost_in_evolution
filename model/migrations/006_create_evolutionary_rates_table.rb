class CreateEvolutionaryRatesTable < ActiveRecord::Migration

  def self.up
    create_table :evolutionary_rates do |t|
      t.integer :alignment_id
      t.float   :gene_rate
      t.integer :position
      t.float   :site_rate
      t.string  :amino_acids
    end
  end

  def self.down
    drop_table :evolutionary_rates
  end

end
