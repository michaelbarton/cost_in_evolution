require File.dirname(__FILE__) + '/config/environment.rb'

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end
