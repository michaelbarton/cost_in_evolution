require File.dirname(__FILE__) + '/helper.rb'

describe EvolutionaryRate do

  before(:each) do
    Gene.create_from_flatfile( Bio::FlatFile.auto(valid_gene).next_entry )
    Alignment.create_from_alignment(File.open(valid_align).read)
  end

  after(:each) do
    clear_all_tables
  end

  # Make private methods public for testing
  EvolutionaryRate.class_eval do
    public :initialize
  end

  describe 'Using temporary directory and files' do

    it 'should create the temporary directory' do
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
