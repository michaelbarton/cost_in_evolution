# Defines a factory for yeast gene alignment YDL177C
Factory.define :alignment_codon do |f|
  f.alignment_id do 
    align = Alignment.first( :include => :gene, :conditions => ['genes.name = ?','YDL177C'])
    raise RuntimeError, 'Required alignment not stored in the database' if align.nil?
    align.id
  end
  f.start_position 0
  f.codons ['---','---','---','ATG']
  f.amino_acids ['X','X','X','M']
  f.gaps true
end
