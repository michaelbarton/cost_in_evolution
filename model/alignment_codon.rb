class AlignmentCodon
  include DataMapper::Resource
  include Validatable

  property :id, Integer,     :serial => true
  property :alignment_id,    Integer
  property :start_position,  Integer
  property :codons,          String
  property :amino_acids,     String
  
  belongs_to :alignment

  validates_presence_of :alignment_id, :start_position, :codons, :amino_acids

  validates_true_for :start_postion, :logic => lambda {
     self.alignment.to_a[self.start_position].sort == self.codons.sort
  }

end
