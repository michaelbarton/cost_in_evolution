require File.dirname(__FILE__) + '/../config/environment.rb'

DataMapper.setup(:default,Needle::Registry.instance[:database_connections]['testing'])
DataMapper.auto_migrate!

Needle::Registry.instance.register(:logger) do
   Logger.new(Needle::Registry.instance.config['log']['testing']) 
end

public 

def clear_all_tables
  [Gene, Alignment, EvolutionaryRate,AlignmentCodon].each do |table|
    table.all.each &:destroy
  end
end
