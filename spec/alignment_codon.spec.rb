require File.dirname(__FILE__) + '/helper.rb'

valid_gene = File.dirname(__FILE__) + '/data/yal037w.fasta.txt'
valid_align = File.dirname(__FILE__) + '/data/yal037w.alignment.txt'

describe AlignmentCodon do

  def test_alignment_codon(ac,position,codons,amino_acids)
    ac.should_not == nil
    ac.start_position.should == position
    ac.codons.sort.should == codons.sort
    ac.amino_acids.sort.should == amino_acids.sort
  end 

  before(:each) do
    clear_all_tables
  end

  after(:each) do
    clear_all_tables
  end

  describe 'Creating a single record' do

    before(:each) do
      Gene.create_from_flatfile(Bio::FlatFile.auto(valid_gene).next_entry)
      Alignment.create_from_alignment(File.open(valid_align).read)
      @ac = AlignmentCodon.new
      @ac.alignment_id = Alignment.first.id
      @ac.start_position = 1
      @ac.codons = ['---','---','ATG']
      @ac.amino_acids = ['-','-','M']
    end

    it 'should be valid' do
      @ac.valid?.should == true
    end

    it 'should save' do
      @ac.save
      AlignmentCodon.all.length.should == 1
    end

    it 'using an incorrect position should cause it to be invalid' do
      @ac.start_position = 2
      @ac.valid?.should == false
    end

    it 'using an incorrect alignment id should cause it to be invalid' do
      @ac.alignment_id = Alignment.first.id + 1
      @ac.valid?.should == false
    end

  end

  describe 'Creating a set of alignment codon records' do

    before(:each) do
      Gene.create_from_flatfile(Bio::FlatFile.auto(valid_gene).next_entry)
      Alignment.create_from_alignment(File.open(valid_align).read)
      AlignmentCodon.create_from_alignment(Alignment.first)
    end

    it 'should create the expected number of records' do
      AlignmentCodon.count.should == 274
    end
 

    it 'should create the expected first record' do
      test_alignment_codon(AlignmentCodon.first,1,['---','---','ATG'],['-','-','M'])
    end

    it 'should create the expected last record' do
      test_alignment_codon(AlignmentCodon.last,274,['TTT','TTT','TTC'],['F','F','F'])
    end

    it 'should create the expected 10th record' do
      test_alignment_codon(AlignmentCodon.first(:start_position => 10),10,['GGT','---','---'],['G','-','-'])
    end

    it 'should create the expected 100th record' do
      test_alignment_codon(AlignmentCodon.first(:start_position => 100),100,['ATA','ATA','GTA'],['I','I','V'])
    end


  end

end
