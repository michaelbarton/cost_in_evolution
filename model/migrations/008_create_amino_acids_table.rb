class CreateAminoAcidsTable < ActiveRecord::Migration

  def self.up
    create_table :amino_acids do |t|
      t.string  :abbrv
      t.string  :short
      t.string  :name
    end
    add_index(:amino_acids, :abbrv, :unique => true)
    add_index(:amino_acids, :short, :unique => true)
    add_index(:amino_acids, :name,  :unique => true)
  end

  def self.down
    drop_table :amino_acids
  end

end
