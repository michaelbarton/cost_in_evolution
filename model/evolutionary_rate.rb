class EvolutionaryRate
  include DataMapper::Resource
  include Validatable

  # This model stores the evoltionary rate of postions in a multiple sequence alignment
  property :id,           Integer,  :serial => true
  property :alignment_id, Integer
  property :gene_rate,    Float,    :precision => 5    # The evolution rate of the entire alignment
  property :position,     Integer                      # The position in the alignment this refers too
  property :site_rate,    Float,    :precision => 5    # The evolutionary rate of that position
  property :amino_acids,  String                       # The amino acids at this positon in the alignment

  belongs_to :alignment

  validates_presence_of :alignment_id, :gene_rate, :position, :site_rate, :amino_acids

  validates_numericality_of :alignment_id, :gene_rate, :position, :site_rate

  def self.codeml_estimate_rate(alignment)
    config = Ladder::CodeML.create_config_file(
      :seqfile      => self.store_in_temp_file(alignment),
      :treefile     => self.generate_tree_file(alignment),
      :seqtype      => 3,
      :ndata        => 1,
      :aaRatefile   => File.expand_path(File.dirname(__FILE__) + '/../data/wag.dat'),
      :RateAncestor => 1
    )

    codeml = Ladder::CodeML.new(File.dirname(__FILE__) + '/../bin/codeml')
    results = codeml.run(config)
    codeml.clean_up

    for i in 1..results[:rates].length - 1 do
      EvolutionaryRate.create(
        :alignment_id => alignment.id,
        :gene_rate    => results[:alpha],
        :position     => i,
        :site_rate    => results[:rates][i][:rate],
        :amino_acids  => results[:rates][i][:data]
      )
    end  
   
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
