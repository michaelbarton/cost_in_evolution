PROJECT_ROOT = File.dirname(__FILE__)

require File.dirname(__FILE__) + '/config/environment.rb'
load File.dirname(__FILE__) + '/analysis/project.rake'

namespace :log do
  desc 'Clears all log files'
  task :clear do
    Dir.glob(PROJECT_ROOT + '/log/*.log').each { |file| File.delete(file) }
  end
end

namespace :db do

  desc "Build database tables based on model defined proterties"
  task :create do
    ActiveRecord::Migrator.migrate(PROJECT_ROOT + '/model/migrations',nil)
  end

  desc "Clears all database tables"
  task :drop do
    ActiveRecord::Migrator.migrate(PROJECT_ROOT + '/model/migrations',0)
  end
end

Spec::Rake::SpecTask.new do |t|
    t.pattern = 'spec/**/*.spec.rb'
end

desc 'Reset then rebuild the project'
task :rebuild => [
  'log:clear',
  'db:drop',
  'db:create',
  'analysis:analysis_rebuild',
  'www_rebuild'
]

desc 'Rebuilds website files'
task :www_rebuild => ['analysis:www_rebuild']
