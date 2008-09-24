require 'pathname'

class RindRunner

  def self.estimate_for(align)
    rr = RindRunner.new(align).run
    AminoAcidFrequency.create_from_frequencies(rr.site_rates,align)
  end


  attr_accessor :site_rates

  def run

    # Create temporary directroy and generate necessary files
    use_tmp_dir
    align_file = generate_alignment_file
    tree_file = generate_tree_file

    begin
      %x|#{Needle::Registry.instance.config['rind']['bin']} -u|
    rescue => ex
      Needle::Registry.instance[:logger].
        error "Error running rind for #{@alignment.gene.name}\n" + ex.message
      unuse_tmp_dir
      return
    end

    if File.exists?('counts')
      self.site_rates = Bio::Rind::Counts.new(File.open('counts').read)
      unuse_tmp_dir
      return self
    else
      unuse_tmp_dir
      throw RuntimeError, "Rind ouput file 'counts' not found"
    end

  end

  def initialize(alignment)
    @alignment=alignment
    @tmp_dir = Needle::Registry.instance.config['rind']['tmp'] + '/' + random_string
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
    tfile = @tmp_dir + '/data'
    File.open(tfile, 'w') {|file| file.puts RindRunner.format_alignment(@alignment)}
    tfile
  end

  def generate_tree_file
    tfile = @tmp_dir + '/treefile'
    File.open(tfile, 'w') {|file| file.puts @alignment.gene_mutations.first.tree}
    tfile
  end

  def self.format_alignment(align)
    string = ''
    align.to_s.split("\n")[1..4].each do |line|
      id,seq = line.strip.split(/\s+/)
      string << "#{id}  #{Bio::Sequence::NA.new(seq).translate}\n"
    end
    string
  end
  
end
