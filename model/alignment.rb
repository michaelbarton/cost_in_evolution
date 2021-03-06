class Alignment < ActiveRecord::Base
  include Validatable
  include Enumerable

  belongs_to :gene
  has_many   :gene_mutations
  has_many   :alignment_codons

  acts_as_summary :length

  validates_presence_of :gene_id,   :alignment, :gene_count, :length,
    :level => 1

  validates_true_for    :gene_count, :logic => lambda { gene_count == 4 },
    :message => 'Alignment should contain four genes',
    :level => 2

  validates_format_of   :alignment, :with => /F(Y[A-Z]{2}\d{3}[CW](-[AB])?)/,
    :message => 'Alignment should contain an S. cerevisiae gene',
    :level => 3

  validates_true_for    :alignment, :logic => lambda {
    re = Regexp.new(/\d+\s\d+/)
    ! re.match(alignment)
    },
    :message => 'Alignment field should not contain alignment count and length',
    :level => 4

  validates_true_for    :gene, :logic => lambda {
    align_sequence = self.sequence_hash["F#{gene.name}"].gsub(/[\s-]+/m,'').strip
    # Chop, chop, chop off the stop codon
    align_sequence == gene.dna.chop.chop.chop
    },
    :message => 'Alignment sequence should match gene sequence',
    :level => 5

  def to_s
    result =  "#{self.gene_count} #{self.length}\n"
    result << self.alignment
  end

  def sequence_array 
    self.alignment.split(/\n/).map{ |x| x.split(/\s+/,2).last.strip }
  end

  def sequence_hash
    self.alignment.split(/\n/).inject(Hash.new) do |hash, line|
      id, sequence = line.split(/\s+/,2)
      hash[id] = sequence.strip
      hash
    end
  end

  def tree
    species = sequence_hash.keys
    "((#{species.detect{|x| x[/^F/]}},#{species.detect{|x| x[/^P/]}})#{species.detect{|x| x[/^M/]}},#{species.detect{|x| x[/^B/]}})"
  end

  def each
    # Three leters or a dash
    codon_re = /[\w-]{3}/
    # Split the sequences into codons
    array_of_codon_arrays = self.sequence_array.map { |s| s.scan(codon_re) }
    # Interleave the arrays
    codons = array_of_codon_arrays.inject { |a,b| a.zip(b) }
    codons.each{ |x| yield x.flatten }
  end

  def self.create_from_alignment(entry)
 
    re = /([PMFB]Y\w\w\d{3}[WC](-AB)?)\s+([ATGC-]+)/m

    # Convert the alignment to standardised format
    # with each line containing the entry name and the text
    header = entry.split("\n").first
    entry = entry.scan(re).inject(header) do |string, matches|
      string << "\n#{matches[0]}   #{matches[2].gsub("\n",'')}"
    end

    entry.strip!

    cerevisiae_gene = self.find_yeast_gene_name(entry)
    if cerevisiae_gene.nil?
      Needle::Registry.instance[:logger].warn(
        "Load alignment: No yeast ORF found in #{self.find_first_entry(entry)} alignment")
      return
    end

    gene = Gene.find_by_name cerevisiae_gene
    if gene.nil?
      Needle::Registry.instance[:logger].warn "Load alignment: #{cerevisiae_gene} is not a verified ORF"
      return 
    end

    align = Alignment.new
    align.gene_id = gene.id
    align.gene_count, align.length = self.alignment_statistics(entry).values
    align.alignment = self.remove_first_line(entry)

    if align.valid?
      align.save
      return align
    else
      align.errors.each {|error| Needle::Registry.instance[:logger].warn "#{gene.name} : #{error}"}
      return
    end

  end

  def self.find_yeast_gene_name(alignment)
    match = /F(Y[A-Z]{2}\d{3}[CW](-[AB])?)/.match(alignment)
    if match
      match[1]
    else
      nil
    end
  end

  def self.alignment_statistics(alignment)
    count,length = /(\d+)\s+(\d+)/.match(alignment).captures
    {:count => count.to_i,:length => length.to_i}
  end

  def self.remove_first_line(entry)
    t = entry.split(/[\n\r]/)
    t[1,t.length] * "\n"
  end
 
  def self.find_first_entry(entry)
    entry.strip.split("\n").first.split(/\s+/)[0]
  end

end
