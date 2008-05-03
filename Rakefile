require File.dirname(__FILE__) + '/config/environment.rb'
load File.dirname(__FILE__) + '/analysis/project.rake'

namespace :db do

  desc "Build database tables based on model defined proterties"
  task :migrate do
    DataMapper::Persistence.auto_migrate!
  end

end
