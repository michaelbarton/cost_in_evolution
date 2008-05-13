require File.dirname(__FILE__) + '/config/environment.rb'

config = YAML::load(File.open(File.dirname(__FILE__) + '/config/config.yml'))

Ramaze::Log.loggers << Ramaze::Informer.new(config['www_log'])

if config['path_rewrite']
  path_re = Regexp.new(config['path_rewrite'])
  Ramaze::Rewrite[path_re] = "%s"
end

Ramaze.start config['ramaze']
