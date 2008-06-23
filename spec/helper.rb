require File.dirname(__FILE__) + '/../config/environment.rb'

method = %q{ def self.default_repository_name; :testing; end }
ObjectSpace.each_object(Class) do |c|
  c.class_eval(method) if c.include?(DataMapper::Resource)
end 

# Drop all tables here somewhere?
DataMapper.auto_migrate!(:testing)

Needle::Registry.instance.register(:logger) do
   Logger.new(Needle::Registry.instance.config['log']['testing']) 
end

public 

def clear_all_tables
  [Gene, Alignment, EvolutionaryRate,AlignmentCodon].each do |table|
    table.all.each &:destroy
  end
end
