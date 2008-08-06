class EvolutionaryRate

  attr_reader :gene_rate, :site_rates

  def self.estimate(alignment)
    EvolutionaryRate.new(alignment).run
  end

  private

  def initialize(alignment)
    @alignment=alignment
    @tmp_dir = "/scratch/local/" + random_string
  end
 
  def random_string
    "#{Time.now.to_i + (rand * 10**10).to_i}"
  end

  def create_tmp_dir
    Dir.mkdir(@tmp_dir)
  end

  def del_tmp_dir
  end

  def use_tmp_dir
  end

  def unuse_tmp_dir
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

  def run

    Needle::Registry.instance[:logger].
      debug "Estimating evolutionary rate for gene alignment #{alignment.gene.name}"

    align_file = self.generate_alignment_file
    tree_file = self.generate_tree_file

    config = Bio::CodeML.create_config_file(
      :seqfile      => align_file,
      :treefile     => tree_file,
      :seqtype      => 3,
      :ndata        => 1,
      :aaRatefile   => File.expand_path(File.dirname(__FILE__) + '/../data/wag.dat'),
      :RateAncestor => 1
    )

    codeml = Bio::CodeML.new(File.dirname(__FILE__) + '/../bin/codeml')
 
    use_tmp_dir

    begin
      codeml.run(config)
    rescue => ex
      Needle::Registry.instance[:logger].
        error "Error running codeml for #{alignment.gene.name}\n" + ex.message
      unuse_tmp_dir
      return
    end

    report = Bio::CodeML::Report.new(@tmp_dir + "/output.txt")

    self.gene_rate = report.alpha
    self.tree_length = report.tree_length
    self.site_rates = Bio::CodeML::Rates.new(@tmp_dir + "/rates")

    unuse_tmp_dir
    File.delete(tree_file)
    File.delete(align_file)
  end

end
