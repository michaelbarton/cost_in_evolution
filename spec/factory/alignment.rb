# YDL177C
Factory.define :alignment do |f|
  f.gene_id do 
    gene = Gene.find_by_name('YDL177C')
    raise RuntimeError, 'Required gene not stored in the database' if gene.nil?
    gene.id
  end
  f.gene_count 4
  f.length 606
  f.alignment do
    align = ''
    File.open(ALIGN) do |f|
      f.readline
      align = f.read.strip
    end
    align
  end
end
