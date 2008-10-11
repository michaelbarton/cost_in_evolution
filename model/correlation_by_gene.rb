class CorrelationByGene < ActiveRecord::Base
  has_one :alignment
  has_one :condition
  has_one :cost_type

  def self.estimate_for(alignment)

    rates, costs = fetch_cost_rate_data(alignment)

    costs.keys.each do |key|
      r = Rustat::Correlation.spearman(rates,costs[key])
      if r <= 1 and r >= -1
        CorrelationByGene.new(
          :alignment_id => alignment.id,
          :condition_id => key.first,
          :cost_type_id => key.last,
          :r            => r
        ).save!
      end
    end
  end

  def self.fetch_cost_rate_data(alignment)

    codons = AlignmentCodon.find(
      :all, 
      :conditions => ["alignment_id = ? AND gaps = ?",alignment.id,false],
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

    [rates,costs]
  end

end
