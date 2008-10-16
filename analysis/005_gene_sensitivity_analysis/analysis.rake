namespace '005' do

  desc 'Clears flux sensitivity data'
  task :clear_flux_sensitivity_data do
    FluxSensitivity.delete_all
  end

  desc 'Loads flux sensitivity data'
  task :load_flux_sensitivity_data do

    conditions = {
      "EX_so4(e)" => Condition.find_by_abbrv('sul').id,
      "EX_pi(e)"  => Condition.find_by_abbrv('phos').id,
      "EX_o2(e)"  => Condition.find_by_abbrv('oxy').id,
      "EX_nh4(e)" => Condition.find_by_abbrv('nit').id,
      "EX_glc(e)" => Condition.find_by_abbrv('car').id
    }
    cost_types = {
      'relative' => CostType.find_by_abbrv('rel').id,
      'absolute' => CostType.find_by_abbrv('abs').id
    }

    data = File.join(PROJECT_ROOT,'data','reaction_fluxes.txt')
    FasterCSV.open(data,:headers => true,:col_sep => "\t").each do |row|
      gene = Gene.find_by_name(row['gene'])
      if gene
        cost_types.each do |name,cost|
          FluxSensitivity.new(
            :gene_id       => gene.id,
            :condition_id  => conditions[row['environment']],
            :cost_type_id  => cost,
            :reaction_name => row['reaction'],
            :estimate      => row[name]
          ).save!
        end
      end
    end
  end

  desc 'Plot site correlation including flux sensitivity'
  task :print_gene_cost_by_flux do
    target = File.join(File.dirname(__FILE__),'r','data','gene_cost_by_flux.csv')
    header = ["gene","condition","cost_type","sensitivity","mean_cost","sd_cost"]

    FasterCSV.open(target,'w') do |csv|

      csv << header

      # Filter for genes with flux sensitivies and an alignment
      Gene.each do |gene|
        next if gene.flux_sensitivities.size > 10 or 
          gene.flux_sensitivities == nil or 
          gene.alignments.size == 0
        
        # Iterate over each flux sensitivity
        gene.flux_sensitivities.each do |flux|
          next if flux.condition.abbrv == 'oxy'
          costs = AlignmentCodonCost.find(:all,
            :conditions => ["alignment_id = ? AND condition_id = ? AND cost_type_id = ? AND gaps = ?",
              gene.alignments.first.id, flux.condition_id, flux.cost_type_id,false],
          :joins => "LEFT JOIN alignment_codons ON alignment_codons.id = alignment_codon_costs.alignment_codon_id")


          csv << [
            gene.name,
            flux.condition.abbrv,
            flux.cost_type.abbrv,
            flux.estimate,
            Rustat::Summary.mean(costs.map(&:mean)),
            Rustat::Summary.standard_deviation(costs.map(&:mean))
          ]
        end
      end
    end
  end

end
