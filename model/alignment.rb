class Alignment < DataMapper::Base
  property :gene_id,    :integer
  property :alignment,  :text
  property :gene_count, :integer
  property :length,     :integer

  def self.create_from_alignment(entry)
 
    cerevisiae_gene = self.find_yeast_gene_name(entry)
    if cerevisiae_gene.nil?
      return
    end

    gene = Gene.first(:name => cerevisiae_gene)
    if gene.nil?
      return 
    end

    stats = self.alignment_statistics(entry)

    Alignment.create(
      :gene_id     => gene.id,
      :alignment   => self.remove_first_line(entry),
      :gene_count  => stats[:count],
      :length      => stats[:length])
  end

  private
  
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
end
