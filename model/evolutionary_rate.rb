class EvolutionaryRate
  include DataMapper::Resource

  # This model stores the evoltionary rate of postions in a multiple sequence alignment
  property :id,           Integer,  :serial => true
  property :alignment_id, Integer
  property :gene_rate,    Float,    :precision => 5    # The evolution rate of the entire alignment
  property :position,     Integer                      # The position in the alignment this refers too
  property :site_rate,    Float,    :precision => 5    # The evolutionary rate of that position
  property :amino_acids,  String                       # The amino acids at this positon in the alignment

  belongs_to :alignment

  def self.codeml_estimate_rate(alignment)
  end
  
  def self.store_in_temp_file(alignment)
    tfile = Tempfile.new('alignment').path
    File.open(tfile, 'w') {|file| file.puts alignment.to_s}
    tfile
  end

  def self.generate_tree_file(alignment)
    tfile = Tempfile.new('tree').path
    File.open(tfile, 'w') {|file| file.puts "(#{(1..alignment.gene_count).to_a * ','})"}
    tfile
  end

end
