namespace '004' do

  desc 'Clears correlations by gene'
  task :clear_correlation_by_gene do
    CorrelationByGene.delete_all
  end

  desc 'Starfish loads correlations by genes'
  task :load_correlation_by_gene do
    Alignment.each {|align| CorrelationByGene.estimate_for(align)}
  end

end
