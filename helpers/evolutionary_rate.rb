require 'pathname'

class EvolutionaryRate

  attr_accessor :gene_rate, :site_rates, :tree_length

  def run

    Needle::Registry.instance[:logger].
      debug "Estimating evolutionary rate for gene alignment #{@alignment.gene.name}"

    # Create temporary directroy and generate necessary files
    use_tmp_dir
    align_file = self.generate_alignment_file
    tree_file = self.generate_tree_file
    out_file = @tmp_dir + "/output"
    config_file = @tmp_dir + "/config"

    Bio::CodeML.create_config_file({
      :outfile      => out_file,
      :seqfile      => align_file,
      :treefile     => tree_file,
      :seqtype      => 3,
      :ndata        => 1,
      :aaRatefile   => Needle::Registry.instance.config['codeml']['wag'],
      :RateAncestor => 1
    },config_file)

    codeml = Bio::CodeML.new(Needle::Registry.instance.config['codeml']['bin'])

    begin
      codeml.run(config_file)
    rescue => ex
      Needle::Registry.instance[:logger].
        error "Error running codeml for #{@alignment.gene.name}\n" + ex.message
      unuse_tmp_dir
      return
    end

    report = Bio::CodeML::Report.new(File.open(out_file).read)

    self.gene_rate = report.alpha
    self.tree_length = report.tree_length
    self.site_rates = Bio::CodeML::Rates.new(File.open(@tmp_dir + "/rates").read)

    unuse_tmp_dir
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
