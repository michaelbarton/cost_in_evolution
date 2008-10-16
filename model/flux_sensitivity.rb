class FluxSensitivity < ActiveRecord::Base
  include Validatable

  belongs_to :gene
  belongs_to :condition
  belongs_to :cost_type

  validates_presence_of :gene_id, :condition_id, :cost_type_id, :reaction_name, :estimate
end
