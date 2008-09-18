Dir.glob(File.dirname(__FILE__) + '/../vendor/*/*/lib') {|dir| $: << File.expand_path(dir)}

require 'erb'
require 'yaml'
require 'enumerator'

require 'rubygems'

require 'active_record'
require 'active_record/fixtures'
require 'haml'
require 'bluecloth'
require 'spec'
require 'spec/rake/spectask'
require 'needle'
require 'statarray'
require 'validatable'
require 'bio'
require 'bio/appl/paml/codeml'
require 'bio/appl/rind/counts'
require 'fastercsv'
require 'rustat'
require 'rustat/acts_as_summary'

class Needle::Registry
  include Singleton
end

r = Needle::Registry.instance
r.register(:config) { YAML::load(File.open(File.dirname(__FILE__) + '/config.yml')) }
r.register(:logger) { Logger.new(r.config['log']['analysis']) }
r.register(:database_connections) {YAML::load(File.open(File.dirname(__FILE__) + '/database.yml'))}

ActiveRecord::Base.logger = Logger.new(r.config['log']['db'])
ActiveRecord::Base.establish_connection(r[:database_connections]['default'])

Dir.glob(File.dirname(__FILE__) + '/../model/*.rb') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/../helpers/*.rb') {|file| require file}
