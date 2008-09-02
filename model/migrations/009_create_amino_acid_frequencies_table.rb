class CreateAminoAcidFrequenciesTable < ActiveRecord::Migration

  def self.up
    create_table :amino_acid_frequencies do |t|
      t.integer :alignment_codon_id
      t.integer :amino_acid_id
      t.float   :frequency
      t.float   :error
    end
  end

  def self.down
    drop_table :amino_acid_frequencies
  end

end
