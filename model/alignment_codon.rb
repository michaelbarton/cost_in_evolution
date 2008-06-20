class AlignmentCodon
  include DataMapper::Resource

  property :id, Integer,     :serial => true
  property :alignment_id,    Integer
  property :start_position,  Integer
  property :codons,          String
  property :amino_acids,     String
  
  belongs_to :alignment

  

end
