require 'erb'
require 'yaml'
require 'enumerator'

require 'rubygems'

require 'active_record'
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
r.register(:database_connections) {YAML::load(File.open(File.dirname(__FILE__) + '/database.yml'))}

ActiveRecord::Base.establish_connection(r[:connection]['default'])

Dir.glob(File.dirname(__FILE__) + '/../controller/*.rb') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/../model/*.rb') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/../vendor/*/lib/setup.rb') {|file| require file}
