PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))

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

  desc "Drops, then recreates the database tables"
  task :recreate => [:drop,:create]
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

namespace 'www' do

  desc 'Clears website files and data'
  task :clear do
    Project.delete_all
    Stage.delete_all
    Dir.glob("www/site/*.html").each {|x| File.delete(x)}
  end

  desc 'Loads analysis descriptions'
  task :load => ['clear']do
    # Load project description
    file = PROJECT_ROOT + '/analysis/description.markdown'
    File.open(file) do |f|
      Project.create({
        :title         => f.readline.gsub(/#\s+/,''),
        :description   => f.read,
        :major_version => PROJECT_VERSION.split('.')[0].to_i,
        :minor_version => PROJECT_VERSION.split('.')[1].to_i,
        :tiny_version  => PROJECT_VERSION.split('.')[2].to_i,
        :last_modified => Date.parse(File.mtime(file).to_s)
      })
    end
    # Load stage information
    dirs = Dir.glob(PROJECT_ROOT + '/analysis/*').select {|x| File.directory?(x) }
    dirs.each do |dir|
      n = File.basename(dir).split('-').first.to_i
      Stage.create_from_markdown_erb(n,dir + '/description.markdown.erb')
    end
  end

  desc 'Rebuilds website files'
  task :build => ['load'] do
    haml = Haml::Engine.new(File.read(PROJECT_ROOT + '/www/views/layout.haml'))
 
    # Hash of pages and corresponding renderable objects
    pages = {
      'index'  => Project.first,
      'stages' => Stage
    }
  
    # Add each stage to pages hash
    Stage.all.each {|stage| pages.store("stage_" + stage.number.to_s,stage)}

    # Render each page
    pages.each do |page,renderable|
      File.open(PROJECT_ROOT + "/www/site/#{page}.html",'w') {|x| x.puts haml.render(renderable)}
    end

  end

end
