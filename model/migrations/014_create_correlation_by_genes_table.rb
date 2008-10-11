class CreateCorrelationByGenesTable < ActiveRecord::Migration

  def self.up
    create_table :correlation_by_genes do |t|
      t.integer :alignment_id
      t.integer :condition_id
      t.integer :cost_type_id
      t.float   :r
    end
    add_index(:correlation_by_genes,
      [:alignment_id, :condition_id, :cost_type_id],
      :unique => true,
      :name   => :correlation_costs_index
    )
  end

  def self.down
    drop_table :correlation_by_genes
  end

end
