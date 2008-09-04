require File.dirname(__FILE__) + '/helper.rb'

describe Gene do

  describe 'creating a valid gene' do

    def load_gene
    end

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

end
