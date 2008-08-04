class CreateAlignmentCodonsTable < ActiveRecord::Migration

  def self.up
    create_table :alignment_codons do |t|
      t.integer :alignment_id
      t.integer :start_position
      t.string  :codons
      t.string  :amino_acids
    end
    add_index(:alignment_codons, :alignment_id)
    add_index(:alignment_codons, [:alignment_id, :start_position], :unique => true)

  end

  def self.down
    drop_table :alignment_codons
  end

end
