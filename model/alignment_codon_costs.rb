class AlignmentCodonCost < ActiveRecord::Base
  belongs_to :alignment_codon
  belongs_to :condition
  belongs_to :cost_type

  def self.create_from_codon(codon)
 
    # Each group of condition and cost
    costs_by_condition_and_type = AminoAcidCost.all :group => ["condition_id"," , ","cost_type_id"]

    # Weights for each amino acid
    frequencies = codon.amino_acid_frequencies.map(&:frequency)

    costs_by_condition_and_type.each do |cost|

      costs = codon.amino_acid_frequencies.map do |freq|
        AminoAcidCost.find(:first, :conditions => {
          :amino_acid_id => freq.amino_acid_id,
          :condition_id  => cost.condition_id,
          :cost_type_id  => cost.cost_type_id
        }).estimate
      end

      AlignmentCodonCost.create(
        :alignment_codon_id => codon.id,
        :condition_id       => cost.condition_id,
        :cost_type_id       => cost.cost_type_id,
        :mean               => self.weighted_mean(costs,frequencies)
      )
    end
  end

  def self.weighted_mean(observations,weights)

    # Degrade gracefully if no observations are passed...
    return nil if observations.size < 1

    # ...or the number of observations does not match the number of weights
    return nil unless observations.size == weights.size

    # Return the observation if there is only one
    return observations.first if observations.size < 2

    weighted_sum = 0
    observations.each_index {|i| weighted_sum +=  weights[i].to_f * observations[i]}
    weighted_sum / weights.inject {|sum,x| sum += x}
  end

end
