require File.dirname(__FILE__) + '/helper.rb'

describe EvolutionaryRate do

  before(:each) do
    Gene.create_from_flatfile( Bio::FlatFile.auto(valid_gene).next_entry )
    Alignment.create_from_alignment(File.open(valid_align).read)
    AlignmentCodons.create_from_alignment(Alignment.first)
  end

  after(:each) do
    clear_all_tables
  end

  # Make private methods public for testing
  EvolutionaryRate.class_eval do
    public :initialize
  end



end
