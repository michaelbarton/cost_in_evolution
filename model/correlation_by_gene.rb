class CorrelationByGene < ActiveRecord::Base
  has_one :alignment
  has_one :condition
  has_one :cost_type

  def self.estimate_for(alignment)

    codons = AlignmentCodon.find(
      :all, 
      :conditions => ["alignment_id = ? AND gaps = ?",444,FALSE],
      :include    => [:site_mutation, :alignment_codon_costs])

    rates = Array.new
    costs = codons.inject(Hash.new) do |hash,codon|
      rates << codon.site_mutation.rate
      codon.alignment_codon_costs.each do |cost|
        hash[[cost.condition_id,cost.cost_type_id]] ||= Array.new
        hash[[cost.condition_id,cost.cost_type_id]] << cost.mean
      end
      hash
    end

    costs.keys.each do |key|
      CorrelationByGene.new(
        :alignment_id => alignment.id,
        :condition_id => key.first,
        :cost_type_id => key.last,
        :r            => Rustat::Correlation.spearman(rates,costs[key])
      ).save!
    end
  end

end
