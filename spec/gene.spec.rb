require File.dirname(__FILE__) + '/helper.rb'

describe Gene do

  before(:all) do
    clear_all_tables
  end

  after(:all) do
    clear_all_tables
  end

  describe 'creating a valid gene' do

   it 'should be valid when created with correct data' do
     gene = Gene.new
     File.open(GENE) do |file|
       gene.name = file.readline.strip.split(/\s+/).first.gsub('>','')
       gene.dna = file.read
     end
     gene.valid?.should == true
   end

   it 'should not return nil when created from bioruby entry' do
     gene = load_gene
     gene.should_not == nil
   end

  end

end
