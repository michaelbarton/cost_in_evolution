require File.dirname(__FILE__) + '/config/environment.rb'

config = YAML::load(File.open(File.dirname(__FILE__) + '/config/config.yml'))

Ramaze::Log.loggers << Ramaze::Informer.new(config['www_log'])
Ramaze.start config['ramaze']
