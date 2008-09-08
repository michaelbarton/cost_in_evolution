class CreateGeneMutationsTable < ActiveRecord::Migration

  def self.up
    create_table :gene_mutations do |t|
      t.integer :alignment_id
      t.float   :alpha
      t.float   :estimated_rate
      t.string  :tree
      t.string  :dataset
    end
    add_index(:gene_mutations,:alignment_id)
  end

  def self.down
    drop_table :gene_mutations
  end

end
