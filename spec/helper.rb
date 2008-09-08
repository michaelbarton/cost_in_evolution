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
  clear_all_tables
  args.each do |table|
    file = File.join(File.dirname(__FILE__),'fixtures',"#{table}.yml")
    entries = YAML.load(File.open(file).read)

    entries.each do |key, entry|
      ActiveRecord::Base.connection.insert(
        "INSERT INTO #{table} (#{entry.keys * ','}) VALUES (#{entry.values.map{|x| "'#{x}'"} * ','});"
      )
    end
  end
end

def clear_all_tables
  ObjectSpace.each_object(Class){|x| x.delete_all if x.superclass == ActiveRecord::Base}
end
