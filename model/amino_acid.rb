class AminoAcidFrequency < ActiveRecord::Base
  belongs_to :alignment_codon
  belongs_to :amino_acid
end
