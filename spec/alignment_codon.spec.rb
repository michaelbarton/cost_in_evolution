require File.dirname(__FILE__) + '/helper.rb'

describe AlignmentCodon do

  def test_alignment_codon(ac,position,codons,amino_acids,gaps)
    ac.should_not be_nil
    ac.start_position.should == position
    ac.codons.should == codons
    ac.amino_acids.should == amino_acids
    ac.gaps.should == gaps
  end 

  fixtures :genes, :alignments

  describe 'Creating a single record' do

    after(:all) do
      AlignmentCodon.delete_all
    end

    before(:all) do
      AlignmentCodon.delete_all
    end

    it 'codons method should return an array' do
      Factory.build(:alignment_codon).codons.should == ['---','---','---','ATG']
    end

    it 'codons should match those expected in the alignment' do
      align_codon = Factory.build(:alignment_codon)
      align_codon.codons.should == align_codon.alignment.to_a[align_codon.start_position]
    end

    it 'translated codons should match expected amino acids' do
      align_codon = Factory.build(:alignment_codon)
      align_codon.codons.inject(Array.new) { |array,codon|
        array << Bio::Sequence::NA.new(codon).translate
      }.should == align_codon.amino_acids
    end

    it 'should be valid' do
      Factory.build(:alignment_codon).valid?.should == true
    end

    it 'should save' do
      Factory(:alignment_codon)
      AlignmentCodon.all.length.should == 1
    end

    it 'using an incorrect position should cause it to be invalid' do
      Factory.build(:alignment_codon, :start_position => 2).valid?.should == false
    end

    it 'using an incorrect alignment id should cause it to be invalid' do
      align_codon = Factory.build(:alignment_codon)
      align_codon.alignment_id += 1
      align_codon.valid?.should == false
    end

    it 'using an incorrect amino acid arrays should cause it to be invalid' do
      Factory.build(:alignment_codon, :amino_acids => ['G','X','X']).valid?.should == false
    end

    it 'setting gaps incorrectly should cause it to be invalid' do
      Factory.build(:alignment_codon, :gaps => false).valid?.should == false
    end
  end

  describe 'Creating a set of alignment codon records' do

    before(:each) do
      AlignmentCodon.delete_all
      AlignmentCodon.create_from_alignment(Alignment.first)
    end

    after(:each) do
      AlignmentCodon.delete_all
    end

    it 'should create the expected number of records' do
      AlignmentCodon.all.length.should == 202
    end

    it 'should create the expected first record' do
      test_alignment_codon(AlignmentCodon.first,0,['---','---','---','ATG'],['X','X','X','M'],true)
    end

    it 'should create the expected last record' do
      test_alignment_codon(AlignmentCodon.find_by_start_position(603),603,['CCC','CAT','CCT','CCT'],['P','H','P','P'],false)
    end

    it 'should create the expected 3rd record' do
      test_alignment_codon(AlignmentCodon.find_by_start_position(9),9,['---','---','---','TTA'],['X','X','X','L'],true)
    end

    it 'should create the expected 33rd record' do
      test_alignment_codon(AlignmentCodon.find_by_start_position(99),99,['GGG','GGA','GGT','GGC'],['G','G','G','G'],false)
    end

  end

end
