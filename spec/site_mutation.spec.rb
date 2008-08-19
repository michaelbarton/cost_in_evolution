require File.dirname(__FILE__) + '/helper.rb'

describe SiteMutation do

  before(:each) do
    load_gene
    load_align
    load_align_codons
  end

  after(:each) do
    clear_all_tables
  end

  describe 'loading site mutation rates' do
    it 'should run without error' do
      er = EvolutionaryRate.new(Alignment.first).run
      lambda {
        SiteMutation.create_from_rates(er.site_rates,Alignment.first)
      }.should_not raise_error
    end
  end

  describe 'the loaded results' do

    before(:each) do
      er = EvolutionaryRate.new(Alignment.first).run
      SiteMutation.create_from_rates(er.site_rates,Alignment.first)
    end

    it 'should create the expected number of entries' do
      SiteMutation.all.length.should == 202
    end

    it 'should store the first entry correctly' do
      sm = AlignmentCodon.find_by_start_position(0).site_mutation
      sm.should_not be_nil
      sm.rate.should == 1.000
    end

    it 'should store the 100th entry correctly' do
      sm = AlignmentCodon.find_by_start_position(99 * 3).site_mutation
      sm.should_not be_nil
      sm.rate.should == 1.779
    end

    it 'should store the last entry correctly' do
      sm = AlignmentCodon.find_by_start_position(201 * 3).site_mutation
      sm.should_not be_nil
      sm.rate.should == 1.752
    end
  end

end
