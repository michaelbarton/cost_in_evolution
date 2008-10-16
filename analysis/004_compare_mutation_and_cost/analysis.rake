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
      csv << ["gene","condition","cost_type","gene_mutation","r"]
      CorrelationByGene.each do |cor|
        csv << [
          cor.alignment.gene.name,
          cor.condition.abbrv,
          cor.cost_type.abbrv,
          GeneMutation.find_by_alignment_id_and_dataset(cor.alignment_id,'Barton2009').estimated_rate,
          cor.r
        ]
      end
    end
  end

  desc 'Print gene cost vs rate data'
  task :print_gene_cost_rate_data do
    target = File.join(File.dirname(__FILE__),'r','data','gene_cost_rate.csv')
    FasterCSV.open(target,'w') do |csv|
      csv << ["gene","cost","tree_length","cost_type","condition"]
      Alignment.each do |align|
        CostType.each  do |cost|
          Condition.each do |condition|
            costs = AlignmentCodonCost.find(:all,
              :conditions => ["condition_id = ? AND cost_type_id = ? AND alignment_id = ? AND gaps = ?",condition.id,cost.id,align.id,false],
              :joins => "LEFT JOIN alignment_codons ON alignment_codons.id = alignment_codon_costs.alignment_codon_id")
            if costs.size > 0
              csv << [
                align.gene.name,
                Rustat::Summary.mean(costs.map{|c| c.mean}),
                GeneMutation.find_by_alignment_id_and_dataset(align.id,'Barton2009').estimated_rate,
                cost.abbrv,
                condition.abbrv
                ]
            end
          end
        end
      end
    end
  end
end
