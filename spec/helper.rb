require File.dirname(__FILE__) + '/../config/environment.rb'

ActiveRecord::Base.establish_connection(Needle::Registry.instance.database_connections['testing'])
[0,nil].each {|i| ActiveRecord::Migrator.migrate(File.dirname(__FILE__) + '/../model/migrations',i)}

Needle::Registry.instance.register(:logger) do
   Logger.new(Needle::Registry.instance.config['log']['testing']) 
end

public 

def clear_all_tables
  [Gene,Alignment,AlignmentCodon,SiteMutation,GeneMutation].each do |table|
    table.delete_all
  end
end
