class AminoAcidFrequency < ActiveRecord::Base
  belongs_to :amino_acid
  belongs_to :alignment_codon
end

