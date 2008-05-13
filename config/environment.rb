require 'erb'
require 'yaml'

require 'rubygems'
require 'ramaze'
require 'data_mapper'
require 'haml'
require 'bluecloth'
require 'bio'
require 'spec'
require 'spec/rake/spectask'

LOGGER = Logger.new('log/analysis.log')

class DataMapper::Base
  @@logger = Logger.new('log/analysis.log')
end

# Load and set up eat of the different databases
YAML::load(File.open(File.dirname(__FILE__) + '/database.yml')).each do |key,value|
  DataMapper::Database.setup(key.to_sym,value)
end

Dir.glob(File.dirname(__FILE__) + '/../controller/*.rb') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/../model/*.rb') {|file| require file}
