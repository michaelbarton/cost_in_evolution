require File.dirname(__FILE__) + '/helper.rb'

describe CorrelationByGene do

  before(:all) do
    fixtures :genes, :alignments, :alignment_codons,
      :conditions, :cost_types, :alignment_codon_costs
  end

  describe 'estimate correlation between site costs and mutation rates' do

    before do
      CorrelationByGene.estimate_for(Alignment.first)
    end

    after do
      CorrelationByGene.delete_all
    end

    it 'should produce the correct number of estimates' do
      CorrelationByGene.count.should == 9
    end

    it 'should estimate the correct weight correlation' do
      weight = CostType.find_by_abbrv('wei')
      unspecified = Condition.find_by_abbv('none')
      CorrelationByGene.find_by_cost_type_and_condition(weight,unspecified).
        should be_close(-0.28944959,0.0001)
    end

    it 'should estimate the correct nitrogen absolute correlation' do
      absolute = CostType.find_by_abbrv('abs')
      nitrogen = Condition.find_by_abbv('nit')
      CorrelationByGene.find_by_cost_type_and_condition(absolute,nitrogen).
        should be_close(-0.15978649,0.0001)
    end

    it 'should estimate the correct sulphur relative correlation' do
      relative = CostType.find_by_abbrv('rel')
      sulphur = Condition.find_by_abbv('sul')
      CorrelationByGene.find_by_cost_type_and_condition(relative,sulphur).
        should be_close(-0.15476049,0.0001)
    end
  end

end
