class Project < DataMapper::Base
  property :title,         :string
  property :summary,       :text
  property :last_modified, :datetime
  property :major_version, :integer
  property :minor_version, :integer
  property :tiny_version,  :integer
end
