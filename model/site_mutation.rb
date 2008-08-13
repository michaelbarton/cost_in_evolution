class SiteMutation < ActiveRecord::Base
  belongs_to :alignment_codon

  def self.create_from_rates(rate_data,alignment)

    # The data for evolutionary rate
    # Treat this as a stack
    rate_data.compact!

    # The codons in the alignment
    codons = alignment.alignment_codons.sort
   
    codons.each do |codon|
      acids = codon.amino_acids.join
      position = rate_data.first

      if position[:data] == acids
        SiteMutation.create(
	  :alignment_codon_id => codon.id,
	  :rate               => position[:rate]
	)
	# Remove this codon from the queue as it has been assigned
	rate_data.shift
      end
    end
  end
end
