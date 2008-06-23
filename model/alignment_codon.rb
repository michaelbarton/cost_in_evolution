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
  }, :message => "Translated codons should match amino acids"

  def codons
    attribute_get(:codons).split(',')
  end
 
  def codons=(codons)
    attribute_set(:codons,codons.join(','))
  end

  def amino_acids
    attribute_get(:amino_acids).split(',')
  end

  def amino_acids=(amino_acids)
    attribute_set(:amino_acids,amino_acids.join(','))
  end

  def self.create_from_alignment(alignment)
    alignment.inject(0) do |index, codons|
      ac = AlignmentCodon.new(
        :alignment_id   => alignment.id,
        :start_position => index,
        :codons         => codons,
        :amino_acids    => codons.inject(Array.new){ |array,codon| array << Bio::Sequence::NA.new(codon).translate }
      )
      if ac.valid?
        ac.save
      else
        ac.errors.each {|error| Needle::Registry.instance[:logger].warn "#{alignment.id}, #{index} : #{error}"}
      end
      index + 3
    end
  end

end
