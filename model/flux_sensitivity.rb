class FluxSensitivity < ActiveRecord::Base
  include Validatable

  belongs_to :gene
  belongs_to :condition
  belongs_to :cost_type
  
  # Gene_id may be nil since there may be reactions for which there is no gene product
  # i.e. the listed ORF is not one verified by SGD
  validates_presence_of :condition_id, :cost_type_id, :reaction_name, :estimate

end
