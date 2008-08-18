class Gene < ActiveRecord::Base
  include Validatable

  has_many :alignments

  validates_presence_of :name, :dna

  # Checks that the sequence has a start codon, a stop codon, and contains only ATGC
  validates_format_of :dna, :with => /^ATG[ATGC\n]+(TAG|TAA|TGA)$/im

  def self.create_from_flatfile(entry)
    gene = Gene.new
    gene.name = entry.definition.split(/\s+/).first
    gene.dna = entry.data.gsub(/\s+/,'')
    if gene.valid?
      gene.save
      return gene
    else
      Needle::Registry.instance[:logger].warn(
       "Load gene: #{gene.name} is not a valid coding ORF")
    end
  end

  def self.longest
    Gene.all.collect{|x| x.dna.length}.max
  end

  def self.shortest
    Gene.all.collect{|x| x.dna.length}.min
  end

  def self.mean
    Gene.all.map{|gene| gene.dna.length}.to_statarray.mean
  end

  def self.standard_deviation
    Gene.all.map{|gene| gene.dna.length}.to_statarray.stddev
  end
end
