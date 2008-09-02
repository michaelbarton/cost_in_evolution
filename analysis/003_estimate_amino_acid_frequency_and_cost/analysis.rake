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

end
