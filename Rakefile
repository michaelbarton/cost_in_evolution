require File.dirname(__FILE__) + '/config/environment.rb'
load File.dirname(__FILE__) + '/analysis/project.rake'


desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end
