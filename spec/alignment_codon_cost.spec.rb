require File.dirname(__FILE__) + '/helper.rb'

describe AlignmentCodonCost do

  before(:all) do
    fixtures :genes, :alignments, :alignment_codons, :amino_acids,
      :amino_acid_frequencies, :conditions, :cost_types, :amino_acid_costs
  end

  describe 'statistics helper methods' do
    it 'should correctly estimate the weighted mean' do
      mean = AlignmentCodonCost.weighted_mean([4,6,3,6,2],[0.8,0.4,0.4,0.9,0.4])
      mean.should be_close(4.482759,0.0001)
    end

    it 'should correctly estimate the weighted deviation' do
      var = AlignmentCodonCost.weighted_variance([4,6,3,6,2],[0.8,0.4,0.4,0.9,0.4])
      var.should be_close(2.919753,0.0001)
    end
  end

  describe 'creating alignment codon costs from codon' do
    it 'should not raise an error' do
      lambda {
        AlignmentCodonCost.create_from_codon(AlignmentCodon.first)
      }.should_not raise_error
        AlignmentCodonCost.delete_all
    end
  end


  describe 'estimated alignment codon costs' do

    before(:all) do
      Alignment.first.alignment_codons.each {|c| AlignmentCodonCost.create_from_codon(c)}
    end

    after(:all) do
      AlignmentCodonCost.delete_all
    end

    it 'should calculate the expected cost for the first codon' do
      AlignmentCodonCost.first.mean.should be_close(149.2, 0.0001)
      AlignmentCodonCost.first.variance.should be_nil
    end
    
    it 'should calculate the expected cost for codon 174' do
      cost = AlignmentCodon.find_by_start_position(174).
        alignment_codon_costs.select{|x| x.cost_type.abbrv == 'wei'}.first
      cost.mean.should be_close(118.0876, 0.01)
      cost.variance.should == 8
    end

    it 'should calculate the expected cost for codon 201' do
      cost = AlignmentCodon.find_by_start_position(201).
        alignment_codon_costs.select{|x| x.cost_type.abbrv == 'wei'}.first
      cost.mean.should be_close(135.1199, 0.01)
      cost.variance.should be_close( 1806.005,0.01)
    end
  end

end
