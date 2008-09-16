class AminoAcidCost < ActiveRecord::Base
  include Validatable

  belongs_to :amino_acid

  validates_presence_of :amino_acid_id, :type, :estimate
end
