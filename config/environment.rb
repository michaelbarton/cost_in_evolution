require 'erb'
require 'yaml'

require 'rubygems'
gem 'dm-core'
require 'data_mapper'

require 'ramaze'
require 'haml'
require 'bluecloth'
require 'bio'
require 'spec'
require 'spec/rake/spectask'
require 'needle'
require 'validatable'

class Needle::Registry
  include Singleton
end

r = Needle::Registry.instance
r.register(:config) { YAML::load(File.open(File.dirname(__FILE__) + '/config.yml')) }
r.register(:logger) { Logger.new(r.config['log']['analysis']) }

# Load and set up eat of the different databases
YAML::load(File.open(File.dirname(__FILE__) + '/database.yml')).each do |key,value|
  DataMapper.setup(key.to_sym,value)
end

Dir.glob(File.dirname(__FILE__) + '/../controller/*.rb') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/../model/*.rb') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/../vendor/*/lib/setup.rb') {|file| require file}
