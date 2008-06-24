require 'zlib'

namespace '001' do

  @number = 1

  desc 'Clears yeast sequence data'
  task :clear_sequence_data do
    Gene.all.each &:destroy
  end

  desc 'Load yeast DNA sequence data'
  task :load_sequence_data => :clear_sequence_data do
    file_gz = PROJECT_ROOT + '/data/yeast_protein_genes.fasta.gz'
    Zlib::GzipReader.open(file_gz) do |file|
      Bio::FlatFile.auto(file).each {|entry| Gene.create_from_flatfile entry }
    end
  end

  desc 'Clears sequence alignment data'
  task :clear_alignment_data do
    Alignment.all.each &:destroy
  end

  desc 'Loads the sequence alignment data'
  task :load_alignment_data => ['clear_alignment_data'] do
    file_gz = PROJECT_ROOT + '/data/yeast_alignments.txt.gz'
    Zlib::GzipReader.open(file_gz) do |file|
      entry = nil
      file.each_line do |line|
        if line =~ /\d+\s\d+/ 
          Alignment.create_from_alignment(entry.strip) if entry
          entry = ''
        end
        entry += line
      end
    end
  end

  desc 'Clears alignment codon data'
  task :clear_alignment_codons do
    AlignmentCodon.all.each &:destroy
  end
  
  desc 'Loads all the alignment codon data'
  task :load_alignment_codons => :clear_alignment_codons do
    Alignment.all.each { |a| AlignmentCodon.create_from_alignment(a) }
  end

  desc 'Clears all data, and repeats milestone 001 analysis'
  task :analysis_rebuild => [
    'load_sequence_data',
    'load_alignment_data'
  ]

  desc 'Rebuilds website files'
  task :www_rebuild do
    file = File.dirname(__FILE__) + '/description.markdown.erb'
    Stage.create_from_markdown_erb(@number,file)
  end

end
