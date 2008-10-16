class CreateFluxSensitivityTable < ActiveRecord::Migration

  def self.up
    create_table :flux_sensitivities do |t|
      t.integer :gene_id
      t.integer :condition_id
      t.integer :cost_type_id
      t.string  :reaction_name
      t.float   :estimate
    end
    add_index(:flux_sensitivities,
      [:gene_id,:condition_id,:cost_type_id,:reaction_name], 
      :unique => true, :name => :flux_sensitivities_index)
  end

  def self.down
    drop_table :flux_sensitivities
  end

end
