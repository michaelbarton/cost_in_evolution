class CreateAminoAcidFrequenciesTable < ActiveRecord::Migration

  def self.up
    create_table :amino_acid_frequencies do |t|
      t.integer :alignment_codon_id
      t.integer :amino_acid_id
      t.float   :frequency
      t.float   :error
    end
    add_index(:amino_acid_frequencies,:alignment_codon_id, :name => 'codon_index')
    add_index(:amino_acid_frequencies,:amino_acid_id, :name => 'amino_acid_index')
    add_index(:amino_acid_frequencies,[:alignment_codon_id,:amino_acid_id],
      :unique => true, :name => 'codon_amino_acid_index')
  end

  def self.down
    drop_table :amino_acid_frequencies
  end

end
