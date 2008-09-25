require 'pathname'
require Pathname.new(File.join(File.join(File.dirname(__FILE__),'..','config','environment.rb'))).cleanpath.to_s

FIXTURES_DIR = Pathname.new(File.join(File.join(File.dirname(__FILE__),'..','spec','fixtures'))).cleanpath.to_s

def dump_models(models)
  hash = models.inject(Hash.new) do |hash,model|
    hash[model.id] = model.attributes
    hash
  end
  File.open(File.join(FIXTURES_DIR,"#{models.first.class.table_name}.yml"),'w') do |file|
    file.puts(YAML.dump(hash))
  end
end

dump_models(Condition.all)
dump_models(CostType.all)
dump_models(AminoAcid.all)
dump_models(AminoAcidCost.all)

gene = Gene.find_by_name('YDL177C')
dump_models([gene])

align = gene.alignments
dump_models(align)
dump_models(align.first.gene_mutations)

codons = align.first.alignment_codons
dump_models(codons)

mutations = codons.map{|c| c.site_mutation}
dump_models(mutations)

frequencies = codons.map{|c| c.amino_acid_frequencies}.flatten
dump_models(frequencies)
