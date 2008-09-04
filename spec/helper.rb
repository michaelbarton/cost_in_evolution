require File.dirname(__FILE__) + '/../config/environment.rb'

ActiveRecord::Base.establish_connection(Needle::Registry.instance.database_connections['testing'])
[0,nil].each {|i| ActiveRecord::Migrator.migrate(File.dirname(__FILE__) + '/../model/migrations',i)}

Needle::Registry.instance.register(:logger) do
   Logger.new(Needle::Registry.instance.config['log']['testing']) 
end

public 

GENE = File.expand_path(File.dirname(__FILE__) + '/data/ydl177c.fasta.txt')
ALIGN = File.expand_path(File.dirname(__FILE__) + '/data/ydl177c.alignment.txt')

def load_gene
  Gene.create_from_flatfile( Bio::FlatFile.auto(GENE).next_entry )
end

def load_align
  Alignment.create_from_alignment(File.open(ALIGN).read)
end

def load_align_codons
  AlignmentCodon.create_from_alignment(Alignment.first)
end

def estimate_rates
  EvolutionaryRate.estimate_for(Alignment.first)
end

def load_amino_acids
  dir = File.dirname(__FILE__) + '/../data'
  Fixtures.create_fixtures(dir,'amino_acids')
end

def clear_all_tables
  [Gene,Alignment,AlignmentCodon,SiteMutation,GeneMutation].each do |table|
    table.delete_all
  end
end
