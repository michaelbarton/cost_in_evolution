class AminoAcid < ActiveRecord::Base
  has_many :amino_acid_costs
  has_many :amino_acid_frequencies
end
