require File.dirname(__FILE__) + '/helper.rb'

valid_gene = File.dirname(__FILE__) + '/data/yal037w.fasta.txt'
valid_align = File.dirname(__FILE__) + '/data/yal037w.alignment.txt'

describe EvolutionaryRate do

  before(:each) do
    Gene.create_from_flatfile( Bio::FlatFile.auto(valid_gene).next_entry )
    Alignment.create_from_alignment(File.open(valid_align).read)
  end

  after(:each) do
    clear_all_tables
  end

  describe 'Loading alignment into a temporary file' do
    it 'should load the correct data' do
      file = EvolutionaryRate.store_in_temp_file(Alignment.all.first)
      File.open(file).read.should == File.open(valid_align).read
    end
  end

  describe 'Creating a temporary tree file' do
    it 'should generate the expected output' do
      file = EvolutionaryRate.generate_tree_file(Alignment.all.first)
      File.open(file).read.strip.should == '((FYAL037W,PYAL037W)BYAL037W)'
    end
  end

  describe 'Running codeml analysis' do
    it 'should not throw an error' do
      lambda {
        EvolutionaryRate.codeml_estimate_rate(Alignment.all.first)
      }.should_not raise_error
    end
  end

  describe 'Codeml results' do 

   before do
     EvolutionaryRate.codeml_estimate_rate(Alignment.all.first)
   end

   it 'should have the expected number of resuts' do
     EvolutionaryRate.all.length.should == 262
   end

   it 'should have the correct alignment association' do
     EvolutionaryRate.first.alignment.should_not == nil
     EvolutionaryRate.first.alignment.gene.should_not == nil
     EvolutionaryRate.first.alignment.gene.name.should == "YAL037W"
   end
   
   it 'the first position should have the expected results' do
     position = EvolutionaryRate.find_by_position(1)
     position.site_rate.should == 0.710
     position.amino_acids.should == "MMM"
   end

   it 'the 100th position should have the expected results' do
     position = EvolutionaryRate.find_by_position(100)
     position.site_rate.should == 1.334
     position.amino_acids.should == "GGS"
   end

   it 'the last position should have the expected results' do
     position = EvolutionaryRate.find_by_position(262)
     position.site_rate.should == 0.844
     position.amino_acids.should == "FFF"
   end

  end

end
