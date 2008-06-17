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
      File.open(file).read.strip.should == '(1,2,3)'
    end
  end

  describe 'Doing codeml analysis' do

    it 'should not throw an error' do
      lambda {
        EvolutionaryRate.codeml_estimate_rate(Alignment.all.first)
      }.should_not raise_error
    end

  end

end
