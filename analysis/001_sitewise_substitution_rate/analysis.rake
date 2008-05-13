require 'zlib'

namespace '001' do

  @number = 1

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
        if line =~ /\d\s\d+/ 
          Alignment.create_from_alignment(entry.strip) if entry
          entry = line
        end
        entry += line
      end
    end
  end

  desc 'Clears all data, and repeats milestone 001 analysis'
  task :analysis_rebuild => [
    'load_sequence_data',
    'load_alignment_data'
  ]

  desc 'Rebuilds website files'
  task :www_rebuild do
    Milestone.all(:number => @number){|record| record.destroy!}
    file = File.dirname(__FILE__) + '/description.markdown.erb'
    File.open(file) do |f|
      Milestone.create({
        :number        => @number,
        :title       => f.readline.gsub('# ','').strip,
        :description => ERB.new(f.read.strip).result
      })
    end
  end

end
