class Alignment
  include DataMapper::Resource
  include Validatable
  include Enumerable

  property :id,         Integer,  :serial => true
  property :gene_id,    Integer
  property :alignment,  Text
  property :gene_count, Integer
  property :length,     Integer

  belongs_to :gene
  has n,     :evolutionary_rate 

  validates_presence_of :gene_id,   :alignment, :gene_count, :length

  validates_true_for    :alignment, :logic => lambda {
    re = Regexp.new(/\d+\s\d+/)
    ! re.match(alignment)
  }, :message => 'Alignment field should not contain alignment count and length'

  validates_format_of   :alignment, :with => /F(Y[A-Z]{2}\d{3}[CW](-[AB])?)/,
    :message => 'Alignment should contain an S. cerevisiae gene'

  def to_s
    result =  "#{self.gene_count} #{self.length}\n"
    result << self.alignment
  end

  def sequences 
    self.alignment.split(/\n/).inject(Hash.new) do |hash, line|
      id, sequence = line.split(/\s+/,2)
      hash[id] = sequence.strip
      hash
    end
  end

  def each
    codons = Array.new
    self.sequences.values.each do |s|
      tmp = Array.new
      s.split(//).each_slice(3) {|codon| tmp << codon.join}
      tmp.each_with_index do |codon, i| 
        codons[i] ||= Array.new
        codons[i] << codon
      end
    end
    codons.each{ |x| yield x }
  end

  def self.create_from_alignment(entry)
 
    entry.strip!

    cerevisiae_gene = self.find_yeast_gene_name(entry)
    if cerevisiae_gene.nil?
      Needle::Registry.instance[:logger].warn(
        "Load alignment: No yeast ORF found in #{self.find_first_entry(entry)} alignment")
      return
    end

    gene = Gene.first(:name => cerevisiae_gene)
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
    entry.strip.split("\n")[2].split(' ')[0]
  end

end
