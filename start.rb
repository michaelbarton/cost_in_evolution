require File.dirname(__FILE__) + '/config/environment.rb'

config = YAML::load(File.open(File.dirname(__FILE__) + '/config.yml'))

Ramaze::Log.loggers << Ramaze::Informer.new(config['log_file'])
Ramaze.start config['ramaze']
