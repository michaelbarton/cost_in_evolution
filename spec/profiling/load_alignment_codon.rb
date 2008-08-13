require File.dirname(__FILE__) + '/../helper.rb'
require 'ruby-prof'

load_gene
align = load_align

result = RubyProf.profile do
  AlignmentCodon.create_from_alignment(align)
end
clear_all_tables

printer = RubyProf::GraphPrinter.new(result)
printer.print(STDOUT, 0)
