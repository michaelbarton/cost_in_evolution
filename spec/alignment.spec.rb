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

end
