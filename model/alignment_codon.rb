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

  validates_true_for :codons, :logic => lambda {
     self.alignment != nil and
       self.alignment.to_a[self.start_position / 3].sort == self.codons.sort
  }, :message => "Codons should match codons in alignment at start position"

  validates_true_for :start_position, :logic => lambda {
    self.start_position % 3 == 0
  }, :message => "Start position should be a multiple of three"

  validates_true_for :amino_acids, :logic => lambda {
    expected = self.codons.inject(Array.new) do |array,codon|
      array << Bio::Sequence::NA.new(codon).translate
    end
    self.amino_acids.sort == expected.sort
  }

end
