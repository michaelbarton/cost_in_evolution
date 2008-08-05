require File.dirname(__FILE__) + '/helper.rb'

GENE = File.dirname(__FILE__) + '/data/yal037w.fasta.txt'
ALIGN = File.dirname(__FILE__) + '/data/yal037w.alignment.txt'

describe EvolutionaryRate do

  before(:each) do
    Gene.create_from_flatfile( Bio::FlatFile.auto(GENE).next_entry )
    Alignment.create_from_alignment(File.open(ALIGN).read)
  end

  after(:each) do
    clear_all_tables
  end

  # Make private methods public for testing
  EvolutionaryRate.class_eval do
    public :initialize
    public :create_tmp_dir
    attr_reader :tmp_dir
  end

  describe 'Using temporary directory and files' do

    EVO_RATE = EvolutionaryRate.new(Alignment.first)

    it 'should create the temporary directory' do
      EVO_RATE.create_tmp_dir
      File.directory?(EVO_RATE.tmp_dir).should == true
      Dir.delete(EVO_RATE.tmp_dir)
    end

    it 'should create the temporary alignment file' do
    end

    it 'should create the temporary tree file' do
    end

    it 'should delete the temporary directory and all files' do
    end

    it 'should switch working directory to temporary directory' do
    end

    it 'should switch back temporary directory to working directory'  do
    end

  end

  describe 'Running estimate evolutionary rate' do

    it 'should run without error' do
    end

    it 'should return expected gene rate' do
    end

    it 'should return expected tree length' do
    end

    it 'should return expect site wise rates' do
    end

    it 'should clear all files from the temporary directory' do
    end

  end

end
