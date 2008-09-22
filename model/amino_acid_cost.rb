class AminoAcidCost < ActiveRecord::Base
  include Validatable

  belongs_to :amino_acid
  has_one :condition
  has_one :cost_type

  validates_presence_of :amino_acid_id, :condition_id, :cost_type_id, :estimate
end
