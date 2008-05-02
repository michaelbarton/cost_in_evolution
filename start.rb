require 'rubygems'
require 'ramaze'
require 'yaml'

# require all controllers and models
acquire __DIR__/:controller/'*'
acquire __DIR__/:model/'*'

config = YAML::load(File.open(File.dirname(__FILE__) + '/config.yml'))

class Ramaze::Controller
  URL_ROOT = lambda{config['url_root']}
end

Ramaze::Log.loggers << Ramaze::Informer.new(config['log_file'])
Ramaze.start config['ramaze']
