class SiteMutation < ActiveRecord::Base
  include Validatable
  belongs_to :alignment_codon

  validates_true_for :alignment_codon_id,
    :logic => lambda { self.alignment_codon != nil}

  def self.create_from_rates(rate_data,alignment)

    # Convert rates to a hash of position => rate
    rates = rate_data.inject(Hash.new) do |hash, rate|
      # Replace stars with Xs
      acids = rate[:data].gsub('*','X')
      hash[acids] = rate[:rate]
      hash
    end

    alignment.alignment_codons.each do |codon|
      acids = codon.amino_acids.join

      if rates[acids]
        SiteMutation.create(
	  :alignment_codon_id => codon.id,
	  :rate               => rates[acids]
	)
      end
    end
  end
end
