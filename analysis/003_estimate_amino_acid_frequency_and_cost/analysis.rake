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


end
