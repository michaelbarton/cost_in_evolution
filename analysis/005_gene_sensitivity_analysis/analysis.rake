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
end
