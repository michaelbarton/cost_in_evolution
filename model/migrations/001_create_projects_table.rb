class CreateProjectsTable < ActiveRecord::Migration

  def self.up
    create_table :projects do |t|
      t.text     :title
      t.text     :summary
      t.datetime :last_modified
      t.integer  :major_version
      t.integer  :minor_version
      t.integer  :tiny_version
    end
  end

  def self.down
    drop_table :projects
  end

end
