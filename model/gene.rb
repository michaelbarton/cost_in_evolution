class Gene < DataMapper::Base
  property :name,  :string
  property :dna,   :text
end
