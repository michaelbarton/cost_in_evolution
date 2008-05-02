require 'rubygems'
require 'ramaze'
require 'yaml'
require 'activerecord'

ActiveRecord::Base.establish_connection(YAML::load(File.open(File.dirname(__FILE__) + '/database.yml')))

Dir.glob(File.dirname(__FILE__) + '/../controller/*.rb') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/../model/*.rb') {|file| require file}
