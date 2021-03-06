require File.dirname(__FILE__) + '/helper.rb'

describe Gene do

  before(:all) do
    fixtures
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

    it 'should save to the database' do
      gene = Gene.create_from_flatfile( Bio::FlatFile.auto(GENE).next_entry )
      Gene.all.length.should == 1
      gene.destroy
    end

    it 'should have the correct name' do
      gene = Gene.create_from_flatfile( Bio::FlatFile.auto(GENE).next_entry )
      gene.name.should == 'YDL177C'
      gene.destroy
    end

    it 'should store the expected sequence in the database' do
      gene = Gene.create_from_flatfile( Bio::FlatFile.auto(GENE).next_entry )
      gene.dna.should == 'ATGAGTAAGAATGTTGGTAAGCTAGTGAAAATATGGAATGAATCAGAAGTTTTAGTTGATAGAAAATCGAAATTTCAAGCAAGATGTTGCCCATTACAAAATCAAAAGGATATACCCTCCATACTCCAAGAACTAACGCAAAACAACAAAAGCGTCTCCAAGGCATCCCACATGCACATGTATGCCTGGAGAACGGCCGAGGTATCAAATAATTTGCACTTACAACAAGAGCAGAAAAAGAAGGGCAATAAAGCAAATAAGAGTAATAATAGTCATGTTAACAAGTCAAGGAACATAACGGTGCAGCCAAAGAACATTGAGCAAGGATGTGCTGACTGTGGCGAAGCTGGTGCTGGACAGCGTTTATTGACCTTACTTGAAAGAGCAAACATATTCAACGTCTTGGTAATAGTGACCAGATGGTATGGTGGCACGCCTTTGGGCTCATCAAGATTCAGACACATTTCAACATGTGCAGTGGAAACCTTAAAGAAGGGTGGATTTCTTCCTTAA'
      gene.destroy
    end

  end

  describe 'an existing gene' do

    it 'should return the expected molecular weight' do
      Factory(:gene).total_protein_weight.should be_close(19057.8242, 0.1)
    end

    it 'should return the average residue weight' do
      Factory(:gene).average_residue_weight.should be_close(112.104, 0.1)
    end

  end

end
