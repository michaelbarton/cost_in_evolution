class Gene < ActiveRecord::Base
  include Validatable

  has_many :alignments

  validates_presence_of :name, :dna

  # Checks that the sequence has a start codon, a stop codon, and contains only ATGC
  validates_format_of :dna, :with => /^ATG[ATGC\n]+(TAG|TAA|TGA)$/im

  acts_as_summary :dna,
    :map   => lambda {|dna| dna.length},
    :name  => :sequence_length

  def self.create_from_flatfile(entry)
    gene = Gene.new
    gene.name = entry.definition.split(/\s+/).first
    gene.dna = entry.data.gsub("\n",'').strip
    if gene.valid?
      gene.save
      return gene
    else
      Needle::Registry.instance[:logger].warn(
       "Load gene: #{gene.name} is not a valid coding ORF")
    end
  end
end
