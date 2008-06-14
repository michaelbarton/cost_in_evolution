class EvolutionaryRate < DataMapper::Base

  # This model stores the evoltionary rate of postions in a multiple sequence alignment

  property :alignment_id, :integer
  property :gene_rate,    :float    # The evolution rate of the entire alignment
  property :position,     :integer  # The position in the alignment this refers too
  property :site_rate,    :float    # The evolutionary rate of that position
  property :amino_acids,  :string   # The amino acids at this positon in the alignment

end
