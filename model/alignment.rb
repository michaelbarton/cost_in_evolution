class Alignment < DataMapper::Base

  property :gene_id,    :integer
  property :alignment,  :text
  property :gene_count, :integer
  property :length,     :integer

  validates_presence_of :gene_id,   :alignment, :gene_count, :length

  validates_true_for    :alignment, :logic => lambda {
    re = Regexp.new(/\d+\s\d+/)
    ! re.match(alignment)
  }, :message => 'Alignment field should not contain alignment count and length'

  validates_format_of   :alignment, :with => /F(Y[A-Z]{2}\d{3}[CW](-[AB])?)/,
    :message => 'Alignment should contain an S. cerevisiae gene'

  def self.create_from_alignment(entry)
 
    cerevisiae_gene = self.find_yeast_gene_name(entry)
    if cerevisiae_gene.nil?
      @@logger.warn "Load alignment: No yeast ORF found in #{self.find_first_entry(entry)} alignment"
      return
    end

    gene = Gene.first(:name => cerevisiae_gene)
    if gene.nil?
      @@logger.warn "Load alignment: #{cerevisiae_gene} is not a verified ORF"
      return 
    end

    stats = self.alignment_statistics(entry)

    Alignment.create(
      :gene_id     => gene.id,
      :alignment   => self.remove_first_line(entry),
      :gene_count  => stats[:count],
      :length      => stats[:length])
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
    t[1,t.length] * '\n'
  end
 
  def self.find_first_entry(entry)
    entry.strip.split("\n")[2].split(' ')[0]
  end


end
