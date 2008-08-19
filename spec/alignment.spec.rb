require File.dirname(__FILE__) + '/helper.rb'

describe Alignment do

  after(:each) do
    clear_all_tables
  end

  describe 'Creating a valid record' do

    before(:each) do
      load_gene
      @align = load_align
    end

    it 'should be valid' do
      @align.valid?.should == true
    end

    it 'should be saved to the database' do
      Alignment.all.length == 1
    end

    it 'should have the correct length' do
      @align.length.should == 606
    end

    it 'should have the correct gene count' do
      @align.gene_count.should == 4
    end

    it 'should have the correct tree' do
      @align.tree.should == "(((FYDL177C,PYDL177C)MYDL177C)BYDL177C)"
    end

    it 'should contain the correct alignment' do
      File.open(ALIGN) do |f|
        f.readline
        @align.alignment.should == f.read.strip
      end
    end

    it 'should return the correct hash map' do
      @align.sequence_hash.should_not == nil
      @align.sequence_hash.keys.sort.should == ['FYDL177C','PYDL177C','BYDL177C','MYDL177C'].sort
      @align.sequence_hash['FYDL177C'].should == '------------------------------------------------------------------------------------ATGAGTAAGAATGTTGGTAAGCTAGTGAAAATATGGAATGAATCAGAAGTTTTAGTTGATAGAAAATCGAAATTTCAAGCAAGATGTTGCCCATTACAAAATCAAAAGGATATACCCTCCATACTCCAAGAACTAACGCAAAACAACAAAAGCGTCTCCAAGGCATCCCACATGCACATGTATGCCTGGAGAACGGCCGAGGTATCAAATAATTTGCACTTACAA---------CAAGAGCAGAAAAAGAAGGGCAATAAAGCAAATAAGAGTAATAATAGT---CATGTTAACAAGTCAAGGAACATAACGGTGCAGCCAAAGAACATTGAGCAAGGATGTGCTGACTGTGGCGAAGCTGGTGCTGGACAGCGTTTATTGACCTTACTTGAAAGAGCAAACATATTCAACGTCTTGGTAATAGTGACCAGATGGTATGGTGGCACGCCTTTGGGCTCATCAAGATTCAGACACATTTCAACATGTGCAGTGGAAACCTTAAAGAAGGGTGGATTTCTTCCT'
    end

    it 'should return the correct sequence array' do
      @align.sequence_array.should_not == nil
      @align.sequence_array[0][0..9].should == '----------'
      @align.sequence_array[1][0..9].should == '----------'
      @align.sequence_array[2][0..9].should == '----------'
      @align.sequence_array[3][0..9].should == 'ATGCATCACT'
    end

   it 'should be comparable' do
     (@align.is_a? Enumerable).should == true
     (@align.respond_to? :each).should == true
   end

   it 'should implement each correctly' do
     @align.to_a.first.should == ['---','---','---','ATG']
     @align.to_a[10].should == ['---','---','---','TTA']
     @align.to_a[100].should == ['AAT','AAC','CAC','AAC']
     @align.to_a.last.should == ['CCC','CAT','CCT','CCT']
   end

  end

  describe 'Creating a non valid record' do
  
    before do
      @align = Alignment.new
      @align.gene_id = 1
      @align.gene_count = 4
      @align.length = 4
    end

    it 'should not be valid when alignment field missing' do
      @align.valid?.should_not == true
      @align.errors.length.should == 1
      @align.errors.to_a.first.should == [:alignment, ["can't be empty"]]
    end

    it 'should not be valid when count info included' do
      @align.alignment = "3 10\nFYAL001W ATG..."
      @align.valid?.should_not == true
      @align.errors.length.should == 1
      @align.errors.to_a.first.should == [:alignment, ["Alignment field should not contain alignment count and length"]]
    end

    it 'should not be valid when an S. cerevisiae is gene missing from alignment' do
      @align.alignment = "ATG..."
      @align.valid?.should_not == true
      @align.errors.length.should == 1
      @align.errors.to_a.first.should == [:alignment, ["Alignment should contain an S. cerevisiae gene"]]
    end

    it 'should not be valid when there are not four genes' do
      @align.alignment = 'ATG...'
      @align.gene_count = 3
      @align.valid?.should_not == true
      @align.errors.length.should == 1
      @align.errors.to_a.first.should == [:gene_count, ["Alignment should contain four genes"]]
    end

    it 'should not be valid when the gene sequence does not match the alignment' do
      gene = load_gene
      align = load_align

      gene.dna[10..10] = 'AAAAAA'
      gene.save!

      @align.valid?.should_not == true
      @align.errors.length.should == 1
      @align.errors.to_a.first.should == [:gene, ["Alignment sequence should match gene sequence"]]
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

  describe 'Alignment to string' do

    before do
      load_gene
      @align = load_align
    end

    it 'should return the alignment in string format' do
     @align.to_s.strip.should == File.open(ALIGN).read.strip
    end

  end

end
