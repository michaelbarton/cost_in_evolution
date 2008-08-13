require File.dirname(__FILE__) + '/helper.rb'

describe SiteMutation do

  before(:each) do
    Gene.create_from_flatfile( Bio::FlatFile.auto(GENE).next_entry )
    Alignment.create_from_alignment(File.open(ALIGN).read)
    AlignmentCodon.create_from_alignment(Alignment.first)
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
      SiteMutation.all.length.should == 262
    end

    it 'should store the first entry correctly' do
      sm = AlignmentCodon.find_by_start_position(12).site_mutation
      sm.should_not be_nil
    end
  end

end
