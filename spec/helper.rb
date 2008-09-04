require File.dirname(__FILE__) + '/../config/environment.rb'
require 'factory_girl'
Dir.glob(File.dirname(__FILE__) + '/factory/*.rb') {|file| require file}

ActiveRecord::Base.establish_connection(Needle::Registry.instance.database_connections['testing'])
[0,nil].each {|i| ActiveRecord::Migrator.migrate(File.dirname(__FILE__) + '/../model/migrations',i)}

Needle::Registry.instance.register(:logger) do
   Logger.new(Needle::Registry.instance.config['log']['testing']) 
end

public 

GENE = File.expand_path(File.dirname(__FILE__) + '/data/ydl177c.fasta.txt')
ALIGN = File.expand_path(File.dirname(__FILE__) + '/data/ydl177c.alignment.txt')

def fixtures(*args)
  dir = File.join(File.dirname(__FILE__),'fixtures')
  args.each{|x| Fixtures.create_fixtures(dir,x.to_s) }
end

def clear_all_tables
  [Gene,Alignment,AlignmentCodon,SiteMutation,GeneMutation].each do |table|
    table.delete_all
  end
end
