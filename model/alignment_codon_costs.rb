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
        :mean               => self.weighted_mean(costs,frequencies),
        :variance           => self.weighted_variance(costs,frequencies)
      )
    end
  end

  def self.weighted_mean(observations,weights)
    weighted_sum = 0
    observations.each_index {|i| weighted_sum +=  weights[i].to_f * observations[i]}
    weighted_sum / weights.inject {|sum,x| sum += x}
  end

  def self.weighted_variance(observations,weights)

    return nil if observations.size < 2

    weighted_mean = self.weighted_mean(observations,weights)

    weighted_sum_of_deviations = 0
    observations.each_index do |i| 
      weighted_sum_of_deviations += (((observations[i] - weighted_mean) ** 2) * weights[i])
    end

    sum_of_square_weights = weights.inject(0) {|sum,x| sum += x**2 }
    sum_of_weights = weights.inject(0) {|sum,x| sum += x }
    unbiased_denominator = sum_of_weights / (sum_of_weights**2 - sum_of_square_weights)

   weighted_sum_of_deviations * unbiased_denominator
  end

end
