require 'erb'
require 'yaml'

require 'rubygems'
require 'ramaze'
require 'data_mapper'
require 'haml'
require 'bluecloth'
require 'bio'

LOGGER = Logger.new('log/analysis.log')

class DataMapper::Base
  @@logger = Logger.new('log/analysis.log')
end


DataMapper::Database.setup(
  YAML::load(
    File.open(File.dirname(__FILE__) + '/database.yml')
  )
)

Dir.glob(File.dirname(__FILE__) + '/../controller/*.rb') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/../model/*.rb') {|file| require file}
