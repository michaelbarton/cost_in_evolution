require 'rubygems'
require 'ramaze'
require 'yaml'

# require all controllers and models
acquire __DIR__/:controller/'*'
acquire __DIR__/:model/'*'

config = YAML::load(File.open('config.yml'))

Ramaze.start config['ramaze']
