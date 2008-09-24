class AminoAcidFrequency < ActiveRecord::Base
  belongs_to :amino_acid
  belongs_to :alignment_codon

  def self.create_from_frequencies(freq,alignment)

    freq.each_with_index do |hash,position|
      codon = AlignmentCodon.find_by_alignment_id_and_start_position(alignment.id,position*3)
      hash.each do |amino_acid, rates|
        unless codon.amino_acids.include? amino_acid
	  raise ArgumentException, "alignment codon #{codon.id} does not contain amino acid #{amino_acid}"
	end
	AminoAcidFrequency.create(
          :alignment_codon_id => codon.id,
          :amino_acid_id      => AminoAcid.find_by_abbrv(amino_acid).id,
          :frequency          => rates[0],
          :error              => rates[1]
	)
      end
    end

  end

end

