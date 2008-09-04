require File.dirname(__FILE__) + '/helper.rb'

describe SiteMutation do

  fixtures :genes, :alignments, :alignment_codons

  describe 'saving a site mutation rate' do
  
    after(:each) do
      SiteMutation.delete_all
    end

    it 'should be valid' do
      Factory.build(:site_mutation).valid?.should == true
    end

    it 'should not be valid if corresponding alignment codon does not exist' do
      non_existant_codon_id = 10000
      Factory.build(:site_mutation, :alignment_codon_id => non_existant_codon_id).valid?.should == false
    end

    it 'should not save if there is already an existing site mutation with the same alignment codon id' do
      Factory(:site_mutation)
      lambda {Factory(:site_mutation)}.should raise_error
    end

  end

  describe 'loading site mutation rates' do

    after(:each) do
      SiteMutation.delete_all
    end

    it 'should run without error' do
      er = EvolutionaryRate.new(Alignment.first).run
      lambda {
        SiteMutation.create_from_rates(er.site_rates,Alignment.first)
      }.should_not raise_error
    end
  end

  describe 'the loaded results' do

    before(:all) do
      er = EvolutionaryRate.new(Alignment.first).run
      SiteMutation.create_from_rates(er.site_rates,Alignment.first)
    end

    after(:all) do
      SiteMutation.delete_all
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
