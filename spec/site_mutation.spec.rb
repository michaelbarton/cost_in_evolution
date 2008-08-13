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
      lambda {
        SiteMutation.create_from_rates(EvolutionaryRate.new(Alignment.first).run.site_rates)
      }.should not_raise
    end
  end

  describe 'the loaded results' do

    before(:each) do
      SiteMutation.create_from_rates(EvolutionaryRate.new(Alignment.first).run.site_rates)
    end

    it 'should store the first entry correctly' do
      sm = AlignmentCodon.find_by_start_position(12).site_mutation
      sm.should_not be_nil
    end
  end

end
