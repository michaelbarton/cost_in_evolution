class Milestone < DataMapper::Base
  property :number,      :integer
  property :title,       :text
  property :description, :text

  belongs_to :project
end
