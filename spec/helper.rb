require File.dirname(__FILE__) + '/../config/environment.rb'

DataMapper.database(:testing) do
  DataMapper::Persistence.drop_all_tables!
  DataMapper::Persistence.auto_migrate!
end

class Gene
  def self.default_repository_name
    :test
  end
end 

class Alignment
  def self.default_repository_name
    :test
  end
end 
