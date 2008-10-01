namespace '003' do

  desc 'Clears stored amino acid data'
  task :clear_amino_acids do
    AminoAcid.delete_all
  end

  desc 'Loads amino acid data'
  task :load_amino_acids => :clear_amino_acids do
    directory = File.join(PROJECT_ROOT,'data')
    Fixtures.create_fixtures(directory,'amino_acids')
  end

  desc 'Clears conditions'
  task :clear_conditions do
    Condition.delete_all
  end

  desc 'Loads conditions'
  task :load_conditions => :clear_conditions do
    directory = File.join(PROJECT_ROOT,'data')
    Fixtures.create_fixtures(directory,'conditions')
  end

  desc 'Clears cost types'
  task :clear_cost_types do
    CostType.delete_all
  end

  desc 'Loads cost types'
  task :load_cost_types => :clear_cost_types do
    directory = File.join(PROJECT_ROOT,'data')
    Fixtures.create_fixtures(directory,'cost_types')
  end

  desc 'Clears amino acid frequency data'
  task :clear_amino_acid_frequency do
    AminoAcidFrequency.delete_all
  end

  desc 'Loads amino acid frequency data'
  task :load_amino_acid_frequency => :clear_amino_acid_frequency do
    starfish = %x|which starfish|.strip
    loader = PROJECT_ROOT + '/model/starfish/load_amino_acid_frequencies.rb'
    p = lambda{ system( "qsub -cwd -j y -V #{starfish} #{loader}") }

    p.call
    sleep(120)
    16.times { p.call }
  end

  desc 'Clears all amino acid cost data'
  task :clear_amino_acid_costs do
    AminoAcidCost.delete_all
  end

  desc 'Loads all amino acid cost data'
  task :load_amino_acid_costs => :clear_amino_acid_costs do
    file = File.join(PROJECT_ROOT,'data','amino_acid_costs.csv')
    FasterCSV.open(file,:headers => :true).each do |row|
      AminoAcidCost.create(
        :amino_acid_id => AminoAcid.find_by_short(row['amino_acid']).id,
        :condition_id  => Condition.find_by_abbrv(row['condition']).id,
        :cost_type_id  => CostType.find_by_abbrv(row['cost_type']).id,
        :estimate      => row['estimate']
      )
    end
  end

  desc 'Prints amino acid cost data'
  task :print_cost_data do
    FasterCSV.open(File.join(File.dirname(__FILE__),'r','data','costs.csv'),'w') do |csv|
      csv << ['amino_acid','type','cost']
      AminoAcidCost.all(:include => :amino_acid).each do |cost|
        csv << [cost.amino_acid.name,cost.name,cost.estimate]
      end
    end
  end


  desc 'Clears alignment codon cost data'
  task :clear_alignment_codon_costs do
    AlignmentCodonCost.delete_all
  end

  desc 'Loads alignment codon cost data'
  task :load_alignment_codon_costs => :clear_alignment_codon_costs do
    starfish = %x|which starfish|.strip
    loader = PROJECT_ROOT + '/model/starfish/load_alignment_codon_costs.rb'
    p = lambda{ system( "qsub -cwd -j y -V #{starfish} #{loader}") }

    p.call
    sleep(120)
    16.times { p.call }
  end

  desc 'Prints average gene cost to file'
  task :print_average_gene_costs do
    target = File.join(File.dirname(__FILE__),'r','data','average_protein_costs.csv')
    sql = File.join(File.dirname(__FILE__),'sql','average_protein_costs.sql')
    output_from_sql(sql,target)
  end

  desc 'Prints alignment codon cost to file'
  task :print_alignment_codon_costs do
    target = File.join(File.dirname(__FILE__),'r','data','alignment_codon_costs.csv')
    sql = File.join(File.dirname(__FILE__),'sql','alignment_codon_costs.sql')
    output_from_sql(sql,target)
  end

end
