class CreateSiteMutationsTable < ActiveRecord::Migration

  def self.up
    create_table :site_mutations do |t|
      t.integer :alignment_codon_id
      t.float   :rate
    end
    add_index(:site_mutations,:alignment_codon_id,:unique => true)
  end

  def self.down
    drop_table :site_mutations
  end

end
