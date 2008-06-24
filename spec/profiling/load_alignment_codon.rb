require File.dirname(__FILE__) + '/../helper.rb'

valid_gene = File.dirname(__FILE__) + '/../data/yal037w.fasta.txt'
valid_align = File.dirname(__FILE__) + '/../data/yal037w.alignment.txt'

Gene.create_from_flatfile(Bio::FlatFile.auto(valid_gene).next_entry)
Alignment.create_from_alignment(File.open(valid_align).read)

align = Alignment.first

AlignmentCodon.create_from_alignment(align)

clear_all_tables
