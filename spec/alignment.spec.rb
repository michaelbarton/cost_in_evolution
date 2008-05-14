require File.dirname(__FILE__) + '/helper.rb'

valid_align = File.dirname(__FILE__) + '/data/yal037w.txt'

describe 'Creating a valid record' do

  before do
    Gene.create(:name => 'YAL037W' , :dna => 'ATG...') 
    @align = Alignment.create_from_alignment(File.open(valid_align).read)
  end

  it 'should be valid' do
    @align.valid?.should == true
  end

  it 'should be saved to the database' do
    Alignment.all.length == 1
  end

  after do
    Alignment.delete_all
    Gene.delete_all
  end

end

describe 'Creating a non valid record' do
  
  before do
    @align = Alignment.new
    @align.gene_id = 1
    @align.gene_count = 1
    @align.length = 3
    end

  it 'should not be valid when alignment field missing' do
    @align.valid?.should_not == true
    @align.errors.length.should == 1
    @align.errors.to_a.first == 'Alignment must not be blank'
  end

  it 'should not be valid when count info included' do
    @align.alignment = "3 10\nFYAL001W ATG..."
    @align.valid?.should_not == true
    @align.errors.length.should == 1
    @align.errors.to_a.first == 'Alignment field should not contain alignment count and length'
  end

  it 'should not be valid when an S. cerevisiae is gene missing from alignment' do
    @align.alignment = "ATG..."
    @align.valid?.should_not == true
    @align.errors.length.should == 1
    @align.errors.to_a.first == 'Alignment should contain an S. cerevisiae gene'
  end

end

describe 'Alignment find yeast gene name' do

  it 'should match and return correct yeast genes' do
    ['FYAL001W','FYAL001C-A','FYAL001W-B'].each do |gene|
      Alignment.find_yeast_gene_name(gene).should == gene[1..gene.length]
    end
  end

  it 'should return nil for incorrect yeast genes' do
    # TODO Test genes that include a - but not followed by A/B
    ['FYAL001Z','FYL001C','FYAL001-B'].each do |gene|
      Alignment.find_yeast_gene_name(gene).should == nil
    end
  end

end

describe 'Alignment remove first line' do

  it 'should correctly strip the first line' do
    test = "AAA\nBBB\nCCC"
    Alignment.remove_first_line(test).should == "BBB\nCCC"
  end
end
