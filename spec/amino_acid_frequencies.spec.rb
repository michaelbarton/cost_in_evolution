require File.dirname(__FILE__) + '/helper.rb'

describe AminoAcidFrequency do

  before(:all) do
    fixtures :genes, :alignments, :alignment_codons, :amino_acids, :gene_mutations, :site_mutations
  end

  describe 'loading site mutation rates' do
    it 'should run without error' do
      rr = RindRunner.new(Alignment.first).run
      lambda {
        AminoAcidFrequency.create_from_frequencies(rr.site_rates,Alignment.first)
      }.should_not raise_error
    end
  end

  describe 'the loaded results' do

    before(:all) do
      rr = RindRunner.new(Alignment.first).run
      AminoAcidFrequency.create_from_frequencies(rr.site_rates,Alignment.first)
    end

    it 'should store the first entry correctly' do
      freq = AlignmentCodon.find_by_start_position(0).amino_acid_frequencies.first
      freq.should_not be_nil
      freq.frequency.should == 1.0
      freq.error.should == 0.0
      freq.amino_acid.short.should == 'met'
    end

    it 'should store the 100th entries correctly' do
      freq = AlignmentCodon.find_by_start_position(100*3).amino_acid_frequencies
      freq.should_not be_nil
      freq.size.should == 2
      acid = AminoAcidFrequency.first :conditions => {
        :alignment_codon_id => AlignmentCodon.find_by_start_position(100*3).id,
	:amino_acid_id      => AminoAcid.find_by_abbrv('H').id
      }
      acid.should_not be_nil
      acid.error.should == 0.0
      acid.frequency.should == 1.0

      acid = AminoAcidFrequency.first :conditions => {
        :alignment_codon_id => AlignmentCodon.find_by_start_position(100*3).id,
	:amino_acid_id      => AminoAcid.find_by_abbrv('N').id
      }
      acid.should_not be_nil
      acid.error.should == 0.371
      acid.frequency.should == 2.951
    end

    it 'should store the last entries correctly' do
      freq = AlignmentCodon.find_by_start_position(201*3).amino_acid_frequencies
      freq.should_not be_nil
      freq.size.should == 2
      acid = AminoAcidFrequency.first :conditions => {
        :alignment_codon_id => AlignmentCodon.find_by_start_position(201*3).id,
	:amino_acid_id      => AminoAcid.find_by_abbrv('H').id
      }
      acid.should_not be_nil
      acid.error.should == 0.0
      acid.frequency.should == 1.0

      acid = AminoAcidFrequency.first :conditions => {
        :alignment_codon_id => AlignmentCodon.find_by_start_position(201*3).id,
	:amino_acid_id      => AminoAcid.find_by_abbrv('P').id
      }
      acid.should_not be_nil
      acid.error.should == 0.639
      acid.frequency.should == 2.839
    end

  end

end
