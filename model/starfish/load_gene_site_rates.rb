require File.dirname(__FILE__) + '/../../config/environment.rb'

server do |map_reduce|
  map_reduce.type = Alignment
  map_reduce.queue_size = 500
end

client do |align|
  er = EvolutionaryRate.new(align).run
  GeneMutation.create(:alignment_id => align.id, :rate => er.gene_rate, :tree_length => er.tree_length)
  SiteMutation.create_from_rates(er.site_rates)
end
