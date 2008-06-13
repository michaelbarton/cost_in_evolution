require File.dirname(__FILE__) + '/helper.rb'

valid_gene = File.dirname(__FILE__) + '/data/yal037w.fasta.txt'

describe Gene do

  before(:all) do
    Gene.delete_all
  end

  after(:all) do
    Gene.delete_all
  end

  describe 'creating a valid gene' do

   it 'should be valid when created with correct data' do
     gene = Gene.new
     File.open(valid_gene) do |file|
       gene.name = file.readline.strip.split(/\s+/).first.gsub('>','')
       gene.dna = file.read
     end
     gene.valid?.should == true
   end

   it 'should not return nil when created from bioruby entry' do
     gene = Gene.create_from_flatfile Bio::FlatFile.auto(valid_gene).next_entry
     gene.should_not == nil
   end

  end

end
