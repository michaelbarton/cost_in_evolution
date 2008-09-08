require File.dirname(__FILE__) + '/helper.rb'

describe Alignment do

  before(:all) do
    fixtures :genes
  end

  describe 'Creating an alignment from file' do

    it 'should be saved to the database' do
      align = Alignment.create_from_alignment(File.open(ALIGN).read)
      Alignment.all.length == 1
      align.destroy
    end

    it 'should derive the correct length' do
      align = Alignment.create_from_alignment(File.open(ALIGN).read)
      align.length.should == 606
      align.destroy
    end

    it 'should derive the correct gene count' do
      align = Alignment.create_from_alignment(File.open(ALIGN).read)
      align.gene_count.should == 4
      align.destroy
    end

    it 'should store the correct alignment' do
      align = Alignment.create_from_alignment(File.open(ALIGN).read)
      File.open(ALIGN) do |f|
        f.readline
        align.alignment.should == f.read.strip
      end
      align.destroy
    end


  end

  describe 'A valid alignment model' do

    it 'should return the correct tree' do
      Factory.build(:alignment).tree.should == "((FYDL177C,PYDL177C)MYDL177C,BYDL177C)"
    end

    it 'should return the correct hash map' do
      align = Factory.build(:alignment)
      align.sequence_hash.should_not == nil
      align.sequence_hash.keys.sort.should == ['FYDL177C','PYDL177C','BYDL177C','MYDL177C'].sort
      align.sequence_hash['FYDL177C'].should == '------------------------------------------------------------------------------------ATGAGTAAGAATGTTGGTAAGCTAGTGAAAATATGGAATGAATCAGAAGTTTTAGTTGATAGAAAATCGAAATTTCAAGCAAGATGTTGCCCATTACAAAATCAAAAGGATATACCCTCCATACTCCAAGAACTAACGCAAAACAACAAAAGCGTCTCCAAGGCATCCCACATGCACATGTATGCCTGGAGAACGGCCGAGGTATCAAATAATTTGCACTTACAA---------CAAGAGCAGAAAAAGAAGGGCAATAAAGCAAATAAGAGTAATAATAGT---CATGTTAACAAGTCAAGGAACATAACGGTGCAGCCAAAGAACATTGAGCAAGGATGTGCTGACTGTGGCGAAGCTGGTGCTGGACAGCGTTTATTGACCTTACTTGAAAGAGCAAACATATTCAACGTCTTGGTAATAGTGACCAGATGGTATGGTGGCACGCCTTTGGGCTCATCAAGATTCAGACACATTTCAACATGTGCAGTGGAAACCTTAAAGAAGGGTGGATTTCTTCCT'
    end

    it 'should return the correct sequence array' do
      align = Factory.build(:alignment)
      align.sequence_array.should_not == nil
      align.sequence_array[0][0..9].should == '----------'
      align.sequence_array[1][0..9].should == '----------'
      align.sequence_array[2][0..9].should == '----------'
      align.sequence_array[3][0..9].should == 'ATGCATCACT'
    end

    it 'should be comparable' do
      align = Factory.build(:alignment)
      (align.is_a? Enumerable).should == true
      (align.respond_to? :each).should == true
    end

    it 'should implement each correctly' do
      align = Factory.build(:alignment)
      align.to_a.first.should == ['---','---','---','ATG']
      align.to_a[10].should == ['---','---','---','TTA']
      align.to_a[100].should == ['AAT','AAC','CAC','AAC']
      align.to_a.last.should == ['CCC','CAT','CCT','CCT']
    end

    it 'should return to string correctly' do
      Factory.build(:alignment).to_s.strip.should == File.open(ALIGN).read.strip
    end
  end

  describe 'Creating a non valid record' do
  
    it 'should not be valid when alignment field missing' do
      align = Factory.build(:alignment, :alignment => nil)
      align.valid?.should_not == true
      align.errors.length.should == 1
      align.errors.to_a.first.should == [:alignment, ["can't be empty"]]
    end

    it 'should not be valid when count info included' do
      align = Factory.build(:alignment, :alignment => "3 10\nFYAL001W ATG...")
      align.valid?.should_not == true
      align.errors.length.should == 1
      align.errors.to_a.first.should == [:alignment, ["Alignment field should not contain alignment count and length"]]
    end

    it 'should not be valid when an S. cerevisiae is gene missing from alignment' do
      align = Factory.build(:alignment, :alignment =>  "ATG...")
      align.valid?.should_not == true
      align.errors.length.should == 1
      align.errors.to_a.first.should == [:alignment, ["Alignment should contain an S. cerevisiae gene"]]
    end

    it 'should not be valid when there are not four genes' do
      align = Factory.build(:alignment, :gene_count => 3)
      align.valid?.should_not == true
      align.errors.length.should == 1
      align.errors.to_a.first.should == [:gene_count, ["Alignment should contain four genes"]]
    end

    it 'should not be valid when the gene sequence does not match the alignment' do
      gene = Gene.create(:name => 'YDL177C', :dna => 'ATGAAATAG')
      align = Factory.build(:alignment, :gene_id => gene.id, :alignment => 'FYDL177C ATG...')
      align.valid?.should_not == true
      align.errors.length.should == 1
      align.errors.to_a.first.should == [:gene, ["Alignment sequence should match gene sequence"]]
      gene.destroy
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

end
