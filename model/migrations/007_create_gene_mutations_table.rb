class CreateGeneMutationsTable < ActiveRecord::Migration

  def self.up
    create_table :gene_mutations do |t|
      t.integer :alignment_id
      t.float   :rate
    end
    add_index(:gene_mutations,:alignment_id,:unique => true)
  end

  def self.down
    drop_table :gene_mutations
  end

end
