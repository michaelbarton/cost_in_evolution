require 'zlib'

namespace '001' do

  desc 'Clears yeast sequence data'
  task :clear_sequence_data do
    Gene.delete_all
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
    Alignment.delete_all
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
    AlignmentCodon.delete_all
  end
  
  desc 'Loads all the alignment codon data'
  task :load_alignment_codons => :clear_alignment_codons do
    starfish = %x|which starfish|.strip
    loader = PROJECT_ROOT + '/model/starfish/load_alignment_codons.rb'
    p = lambda{ system( "qsub -cwd -j y -V #{starfish} #{loader}") }

    p.call
    sleep(120)
    16.times { p.call }
  end

  desc 'Clears all data, and repeats milestone 001 analysis'
  task :analysis_rebuild => [
    'load_sequence_data',
    'load_alignment_data'
  ]

end
