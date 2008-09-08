require File.dirname(__FILE__) + '/../../config/environment.rb'

server do |map_reduce|
  map_reduce.type = Alignment
  map_reduce.queue_size = 500
end

client do |align|
  RindRunner.estimate_for(align)
end
