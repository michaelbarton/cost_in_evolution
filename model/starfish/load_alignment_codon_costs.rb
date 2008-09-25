require File.dirname(__FILE__) + '/../../config/environment.rb'

server do |map_reduce|
  map_reduce.type = AlignmentCodon
  map_reduce.queue_size = 1000
end

client do |codon|
  AlignmentCodonCost.create_from_codon(codon)
end
