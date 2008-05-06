require 'zlib'

namespace '001' do

  desc 'Clears yeast sequence data'
  task :clear_sequence_data do
    Gene.delete_all
  end

  desc 'Load yeast DNA sequence data'
  task :load_sequence_data => :clear_sequence_data do
    file_gz = File.dirname(__FILE__) + '/data/yeast_protein_genes.fasta.gz'
    Zlib::GzipReader.open(file_gz) do |file|
      Bio::FlatFile.auto(file).each {|entry| Gene.create_from_flatfile entry }
    end
  end

  desc 'Clears all data, and repeats milestone 001 analysis'
  task :rebuild => [
    'load_sequence_data'
  ]

end
