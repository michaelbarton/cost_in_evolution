require File.dirname(__FILE__) + '/../helper.rb'
require 'ruby-prof'


load_gene
align = load_align
load_align_codons
er = EvolutionaryRate.new(Alignment.first).run

result = RubyProf.profile do
  SiteMutation.create_from_rates(er.site_rates,align
end

printer = RubyProf::GraphPrinter.new(result)
printer.print(STDOUT, 0)

clear_all_tables
