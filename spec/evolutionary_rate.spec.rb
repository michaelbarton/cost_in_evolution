require File.dirname(__FILE__) + '/helper.rb'

describe EvolutionaryRate do

  before(:each) do
    load_gene
    load_align
  end

  after(:each) do
    clear_all_tables
  end

  # Make private methods public for testing
  EvolutionaryRate.instance_eval do
    public :create_tmp_dir, :del_tmp_dir
    public :generate_alignment_file, :generate_tree_file
    public :use_tmp_dir, :unuse_tmp_dir
    attr_reader :tmp_dir
  end

  describe 'Using temporary directory and files' do

    it 'should create the temporary directory' do
      @evo_rate = EvolutionaryRate.new(Alignment.first)
      @evo_rate.create_tmp_dir
      File.directory?(@evo_rate.tmp_dir).should == true
      Dir.delete(@evo_rate.tmp_dir)
    end

    it 'should create the temporary alignment file' do
      @evo_rate = EvolutionaryRate.new(Alignment.first)
      @evo_rate.create_tmp_dir
      @evo_rate.generate_alignment_file
      File.exists?(@evo_rate.tmp_dir + '/alignment').should == true
      File.open(@evo_rate.tmp_dir + '/alignment').read.should == File.open(ALIGN).read
      File.delete(@evo_rate.tmp_dir + '/alignment')
      Dir.delete(@evo_rate.tmp_dir)
    end

    it 'should create the temporary tree file' do
      @evo_rate = EvolutionaryRate.new(Alignment.first)
      @evo_rate.create_tmp_dir
      @evo_rate.generate_tree_file
      File.exists?(@evo_rate.tmp_dir + '/tree').should == true
      File.open(@evo_rate.tmp_dir + '/tree').read.strip.should == '(((FYDL177C,PYDL177C)MYDL177C)BYDL177C)'
      File.delete(@evo_rate.tmp_dir + '/tree')
      Dir.delete(@evo_rate.tmp_dir)
    end

    it 'should delete the temporary directory and all files' do
      @evo_rate = EvolutionaryRate.new(Alignment.first)
      @evo_rate.create_tmp_dir
      @evo_rate.generate_tree_file
      @evo_rate.generate_alignment_file
      @evo_rate.del_tmp_dir
      File.exists?(@evo_rate.tmp_dir).should == false
    end

    it 'should switch working directory to temporary directory' do
      @evo_rate = EvolutionaryRate.new(Alignment.first)
      current = Dir.getwd
      @evo_rate.use_tmp_dir
      Dir.getwd.should == @evo_rate.tmp_dir
      Dir.chdir(current)
      @evo_rate.del_tmp_dir
    end

    it 'should switch back temporary directory to working directory'  do
      @evo_rate = EvolutionaryRate.new(Alignment.first)
      current = Dir.getwd
      @evo_rate.use_tmp_dir
      @evo_rate.unuse_tmp_dir
      Dir.getwd.should == current
      File.exists?(@evo_rate.tmp_dir).should == false
    end

  end

  describe 'Running estimate evolutionary rate' do

    it 'should run without error' do
      lambda{
        EvolutionaryRate.new(Alignment.first).run
      }.should_not raise_error
    end

    it 'should return expected gene rate' do
      er = EvolutionaryRate.new(Alignment.first)
      er.run
      er.gene_rate.should be_close(0.76386, 0.0001)
    end

    it 'should return expected tree length' do
      er = EvolutionaryRate.new(Alignment.first)
      er.run
      er.tree_length.should == 0.41890
    end

    it 'should return expected number of site wise rates' do
      er = EvolutionaryRate.new(Alignment.first)
      er.run
      er.site_rates.size.should == 202
    end

    it 'the first site rate should have the expected results' do
      er = EvolutionaryRate.new(Alignment.first)
      er.run
      position = er.site_rates[0]
      position[:rate].should == 1
      position[:data].should == "***M"
    end

    it 'the 100th site rate should have the expected results' do
      er = EvolutionaryRate.new(Alignment.first)
      er.run
      position = er.site_rates[99]
      position[:rate].should == 1.779
      position[:data].should == "SLLL"
    end

    it 'the last site rate should have the expected results' do
      er = EvolutionaryRate.new(Alignment.first)
      er.run
      position = er.site_rates.last
      position[:rate].should == 1.752
      position[:data].should == "PHPP"
   end

  end

end
