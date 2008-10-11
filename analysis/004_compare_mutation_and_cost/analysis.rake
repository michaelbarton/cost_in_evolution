namespace '004' do

  desc 'Clears correlations by gene'
  task :clear_correlation_by_gene do
    CorrelationByGene.delete_all
  end

  desc 'Starfish loads correlations by genes'
  task :load_correlation_by_gene do
    Alignment.each {|align| CorrelationByGene.estimate_for(align)}
  end

  desc 'Print gene correlation data'
  task :print_gene_correlation_data do
    target = File.join(File.dirname(__FILE__),'r','data','correlation_by_gene.csv')
    FasterCSV.open(target,'w') do |csv|
      CorrelationByGene.each do |cor|
        csv << [
          cor.alignment.gene.name,
          cor.condition.name,
          cor.cost_type.name,
          cor.r
        ]
      end
    end
  end
 
end
