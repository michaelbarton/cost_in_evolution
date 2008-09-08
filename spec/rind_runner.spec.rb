require File.dirname(__FILE__) + '/helper.rb'

describe RindRunner do

  before(:all) do
    fixtures :genes, :alignments, :alignment_codons, :gene_mutations, :site_mutations
  end

  # Make private methods public for testing
  RindRunner.instance_eval do
    public :create_tmp_dir, :del_tmp_dir
    public :generate_alignment_file, :generate_tree_file
    public :use_tmp_dir, :unuse_tmp_dir
    attr_reader :tmp_dir
  end

  describe 'Using temporary directory and files' do

    it 'should create the temporary directory' do
      rr = RindRunner.new(Alignment.first)
      rr.create_tmp_dir
      File.directory?(rr.tmp_dir).should == true
      Dir.delete(rr.tmp_dir)
    end

    it 'should create the temporary alignment file' do

      expected_align = ''
      File.open(ALIGN) do |file|
        file.readline
        while !file.eof?
          id,seq = file.readline.strip.split(/\s+/)
          expected_align << "#{id}  #{Bio::Sequence::NA.new(seq).translate}\n"
        end
      end

      rr = RindRunner.new(Alignment.first)
      rr.create_tmp_dir
      rr.generate_alignment_file
      File.exists?(rr.tmp_dir + '/data').should == true
      File.open(rr.tmp_dir + '/data').read.should == expected_align
      File.delete(rr.tmp_dir + '/data')
      Dir.delete(rr.tmp_dir)
    end

    it 'should create the temporary tree file' do
      rr = RindRunner.new(Alignment.first)
      rr.create_tmp_dir
      rr.generate_tree_file
      File.exists?(rr.tmp_dir + '/treefile').should == true
      File.open(rr.tmp_dir + '/treefile').read.strip.should ==
        '((FYDL177C: 0.089768, PYDL177C: 0.044688): 0.021206, MYDL177C: 0.096521, BYDL177C: 0.166724);'
      File.delete(rr.tmp_dir + '/treefile')
      Dir.delete(rr.tmp_dir)
    end

    it 'should delete the temporary directory and all files' do
      rr = RindRunner.new(Alignment.first)
      rr.create_tmp_dir
      rr.generate_tree_file
      rr.generate_alignment_file
      rr.del_tmp_dir
      File.exists?(rr.tmp_dir).should == false
    end

    it 'should switch working directory to temporary directory' do
      rr = RindRunner.new(Alignment.first)
      current = Dir.getwd
      rr.use_tmp_dir
      Dir.getwd.should == rr.tmp_dir
      Dir.chdir(current)
      rr.del_tmp_dir
    end

    it 'should switch back temporary directory to working directory'  do
      rr = RindRunner.new(Alignment.first)
      current = Dir.getwd
      rr.use_tmp_dir
      rr.unuse_tmp_dir
      Dir.getwd.should == current
      File.exists?(rr.tmp_dir).should == false
    end

  end

  describe 'Running estimate evolutionary rate' do

    it 'should run without error' do
      lambda{
        RindRunner.new(Alignment.first).run
      }.should_not raise_error
    end

    it 'should return expected number of site wise rates' do
      er = RindRunner.new(Alignment.first)
      er.run
      er.site_rates.should_not == nil
    end

    it 'should return expected number of site wise rates' do
      er = RindRunner.new(Alignment.first)
      er.run
      er.site_rates.size.should == 202
    end

    it 'the first site rate should have the expected results' do
      er = RindRunner.new(Alignment.first)
      er.run
      position = er.site_rates[0]
      position.size.should == 1
      position['M'].should_not == nil
      position['M'].should == [1.0,0.0]
    end

    it 'the tenth site rate should have the expected results' do
      er = RindRunner.new(Alignment.first)
      er.run
      position = er.site_rates[10]
      position.size.should == 1
      position['L'].should_not == nil
      position['L'].should == [1.0,0.0]
    end

    it 'the hundredth site rate should have the expected results' do
      er = RindRunner.new(Alignment.first)
      er.run
      position = er.site_rates[100]
      position.size.should == 2
      position['H'].should_not == nil
      position['H'].should == [1.0,0.0]
      position['N'].should_not == nil
      position['N'].should == [2.951,0.371]
    end

  end

end
