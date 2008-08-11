class AlignmentCodon < ActiveRecord::Base
  include Validatable

  belongs_to :alignment
  has_one    :site_mutation

  validates_presence_of :alignment_id, :start_position, :codons, :amino_acids

  validates_true_for :codons, :logic => lambda {
     self.alignment != nil and
       self.alignment.to_a.at(self.start_position / 3).sort == self.codons.sort
  }, :message => "Codons should match codons in alignment at start position"

  validates_true_for :start_position, :logic => lambda {
    self.start_position % 3 == 0
  }, :message => "Start position should be a multiple of three"

  validates_true_for :amino_acids, :logic => lambda {
    self.amino_acids.sort == self.codons.collect { |codon| Bio::Sequence::NA.new(codon).translate }.sort
  }, :message => "Translated codons should match amino acids"

  def codons
    read_attribute(:codons).split(',')
  end
 
  def codons=(codons)
    write_attribute(:codons,codons.join(','))
  end

  def amino_acids
    read_attribute(:amino_acids).split(',')
  end

  def amino_acids=(amino_acids)
    write_attribute(:amino_acids,amino_acids.join(','))
  end

  def self.create_from_alignment(alignment)
    alignment.inject(0) do |index, codons|
      ac = AlignmentCodon.new(
        :alignment_id   => alignment.id,
        :start_position => index,
        :codons         => codons,
        :amino_acids    => codons.map{ |codon| Bio::Sequence::NA.new(codon).translate }
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
