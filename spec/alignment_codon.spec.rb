require File.dirname(__FILE__) + '/helper.rb'

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
      load_gene
      load_align
      @ac = AlignmentCodon.new
      @ac.alignment_id = Alignment.first.id
      @ac.start_position = 0
      @ac.codons = ['---','---','ATG']
      @ac.amino_acids = ['X','X','M']
    end

    it 'codons method should return an array' do
      @ac.codons.sort.should == ['---','---','ATG'].sort
    end

    it 'codons should match those expected in the alignment' do
      @ac.codons.sort.should == @ac.alignment.to_a[@ac.start_position].sort
    end

    it 'translated codons should match expected amino acids' do
      @ac.codons.inject(Array.new) { |array,codon|
        array << Bio::Sequence::NA.new(codon).translate
      }.sort.should == @ac.amino_acids.sort
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

    it 'using an incorrect amino acid arrays should cause it to be invalid' do
      @ac.amino_acids = ['G','X','X']
      @ac.valid?.should == false
    end

  end

  describe 'Creating a set of alignment codon records' do

    before(:each) do
      load_gene
      load_align
      load_align_codons
    end

    it 'should create the expected number of records' do
      AlignmentCodon.all.length.should == 274
    end

    it 'should create the expected first record' do
      test_alignment_codon(AlignmentCodon.first,0,['---','---','ATG'],['X','X','M'])
    end

    it 'should create the expected last record' do
      test_alignment_codon(AlignmentCodon.find_by_start_position(819),819,['TTT','TTT','TTC'],['F','F','F'])
    end

    it 'should create the expected 3rd record' do
      test_alignment_codon(AlignmentCodon.find_by_start_position(9),9,['GGT','---','---'],['G','X','X'])
    end

    it 'should create the expected 33rd record' do
      test_alignment_codon(AlignmentCodon.find_by_start_position(99),99,['ATA','ATA','GTA'],['I','I','V'])
    end

  end

end
