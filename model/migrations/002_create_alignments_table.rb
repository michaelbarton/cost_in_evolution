class CreateAlignmentsTable < ActiveRecord::Migration

  def self.up
    create_table :alignments do |t|
      t.integer :gene_id
      t.text    :alignment
      t.integer :gene_count
      t.integer :length
    end
  end

  def self.down
    drop_table :alignments
  end

end
