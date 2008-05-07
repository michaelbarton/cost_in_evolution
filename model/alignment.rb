class Alignment < DataMapper::Base
  property :gene_id,    :integer
  property :alignment,  :text
  property :gene_count, :integer
  property :length,     :integer
end
