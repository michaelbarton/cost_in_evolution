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
    Dir.glob(File.join(PROJECT_ROOT,'data','amino_acid_costs','*.csv')) do |file|
      cost_type = File.basename(file).split('.').first
      FasterCSV.open(file,:headers => :true).each do |row|
        amino_acid = AminoAcid.find_by_short(row['amino_acid'])
          a = AminoAcidCost.new
          a.amino_acid_id = amino_acid.id
          a.name          = cost_type
          a.estimate      = row['estimate']
          a.save!
      end
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

end
