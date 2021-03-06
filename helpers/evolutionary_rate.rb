require 'pathname'

class EvolutionaryRate

  def self.estimate_for(align)
    er = EvolutionaryRate.new(align).run
    GeneMutation.create(
      :alignment_id    => align.id,
      :alpha           => er.gene_rate,
      :estimated_rate  => er.tree_length,
      :tree            => er.tree,
      :dataset         => 'Barton2009')
    SiteMutation.create_from_rates(er.site_rates,align)
  end

  attr_accessor :gene_rate, :site_rates, :tree_length, :tree

  def run

    Needle::Registry.instance[:logger].
      debug "Estimating evolutionary rate for gene alignment #{@alignment.gene.name}"

    # Create temporary directroy and generate necessary files
    use_tmp_dir
    align_file = generate_alignment_file
    tree_file = generate_tree_file
    out_file = @tmp_dir + "/output"
    config_file = @tmp_dir + "/config"

    Bio::PAML::Codeml.create_config_file({
      :outfile      => out_file,
      :seqfile      => align_file,
      :treefile     => tree_file,
      :seqtype      => 3,
      :ndata        => 1,
      :aaRatefile   => Needle::Registry.instance.config['codeml']['wag'],
      :RateAncestor => 1,
      :cleandata    => 0
    },config_file)

    codeml = Bio::PAML::Codeml.new(Needle::Registry.instance.config['codeml']['bin'])

    begin
      codeml.run(config_file)
    rescue => ex
      Needle::Registry.instance[:logger].
        error "Error running codeml for #{@alignment.gene.name}\n" + ex.message
      unuse_tmp_dir
      return
    end

    report = Bio::PAML::Codeml::Report.new(File.open(out_file).read)

    self.gene_rate = report.alpha
    self.tree_length = report.tree_length
    self.tree = report.tree
    self.site_rates = Bio::PAML::Codeml::Rates.new(File.open(@tmp_dir + "/rates").read)

    unuse_tmp_dir

    return self
  end

  def initialize(alignment)
    @alignment=alignment
    @tmp_dir = Needle::Registry.instance.config['codeml']['tmp'] + '/' + random_string
    @current_dir = Dir.getwd
  end
 
  private

  def random_string
    "#{Time.now.to_i + (rand * 10**15).to_i}"
  end

  def create_tmp_dir
    Dir.mkdir(@tmp_dir)
  end

  def del_tmp_dir
    Pathname.new(@tmp_dir).rmtree
  end

  def use_tmp_dir
    create_tmp_dir
    Dir.chdir(@tmp_dir)
  end

  def unuse_tmp_dir
    Dir.chdir(@current_dir)
    del_tmp_dir
  end

  def generate_alignment_file
    tfile = @tmp_dir + '/alignment'
    File.open(tfile, 'w') {|file| file.puts @alignment.to_s}
    tfile
  end

  def generate_tree_file
    tfile = @tmp_dir + '/tree'
    File.open(tfile, 'w') {|file| file.puts @alignment.tree}
    tfile
  end
  
end
