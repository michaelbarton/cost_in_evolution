class Gene < DataMapper::Base
  property :name,  :string
  property :dna,   :text

  def self.create_from_flatfile(entry)
    Gene.create(
      :name      =>  entry.definition.split(/\s+/).first,
      :dna       =>  entry.data
    )
  end

end
