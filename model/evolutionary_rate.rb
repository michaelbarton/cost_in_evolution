class EvolutionaryRate < ActiveRecord::Base
  include Validatable

  belongs_to :alignment

  validates_presence_of :alignment_id, :gene_rate, :position, :site_rate, :amino_acids

  validates_numericality_of :alignment_id, :gene_rate, :position, :site_rate

  def self.codeml_estimate_rate(alignment)

    Needle::Registry.instance[:logger].
      debug "Estimating evolutionary rate for gene alignment #{alignment.gene.name}"

    config = Ladder::CodeML.create_config_file(
      :seqfile      => self.store_in_temp_file(alignment),
      :treefile     => self.generate_tree_file(alignment),
      :seqtype      => 3,
      :ndata        => 1,
      :aaRatefile   => File.expand_path(File.dirname(__FILE__) + '/../data/wag.dat'),
      :RateAncestor => 1
    )

    codeml = Ladder::CodeML.new(File.dirname(__FILE__) + '/../bin/codeml')

    begin
      results = codeml.run(config)
    rescue => ex
      Needle::Registry.instance[:logger].
        error "Error running codeml for #{alignment.gene.name}\n" + ex.message
      return
    end
    codeml.clean_up

    for i in 1..results[:rates].length - 1 do

      evo = EvolutionaryRate.new
      evo.alignment_id = alignment.id
      evo.gene_rate    = results[:alpha]
      evo.position     = i
      evo.site_rate    = results[:rates][i][:rate]
      evo.amino_acids  = results[:rates][i][:data]

     if evo.valid?
       evo.save
       Needle::Registry.instance[:logger].
         debug "Saving rate for #{alignment.gene.name} at #{evo.position} at #{evo.site_rate}"
     else
       Needle::Registry.instance[:logger].
         error "Invalid rate model for #{alignment.gene.name} " + evo.errors.full_messages * '\n'
     end

    end  
   
  end
  
end
