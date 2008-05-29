require File.dirname(__FILE__) + '/config/environment.rb'

config = Needle::Registry.instance[:config]

Ramaze::Log.loggers << Ramaze::Informer.new(config['log']['www'])

if config['path_rewrite']
  path_re = Regexp.new(config['path_rewrite'])
  Ramaze::Rewrite[path_re] = "%s"
end

Ramaze.start config['ramaze']
