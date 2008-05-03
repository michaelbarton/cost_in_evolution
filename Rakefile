require File.dirname(__FILE__) + '/config/environment.rb'
load File.dirname(__FILE__) + '/analysis/project.rake'

namespace :db do

  desc "Build database tables based on model defined proterties"
  task :create do
    DataMapper::Persistence.auto_migrate!
  end

  desc "Clears all database tables"
  task :drop do
    DataMapper::Persistence.drop_all_tables!
  end
end

desc 'Reset then rebuild the project'
task :rebuild => [
  'db:drop',
  'db:create',
  'analysis:rebuild'
]
