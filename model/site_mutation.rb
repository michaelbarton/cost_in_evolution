class SiteMutation < ActiveRecord::Base
  belongs_to :alignment_codon

  def self.create_from_rates(array,alignment)

    codons = alignment.alignment_codons.sort

    array.each do |position|
      codon = codons.first
      acids = codon.amino_acids.join

      if position.data == acids
        SiteMutation.create(
	  :alignment_codon_id => codon.id,
	  :rate               => position.rate
	)
	# Remove this codon from the queue as it has been assigned
	codons.shift
      end
    end
  end
end
