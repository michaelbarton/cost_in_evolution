class Project
  include DataMapper::Resource

  property :id,            Integer,  :serial => true
  property :title,         Text
  property :summary,       Text
  property :last_modified, DateTime
  property :major_version, Integer
  property :minor_version, Integer
  property :tiny_version,  Integer

  def html_summary
    BlueCloth.new(self.summary).to_html
  end

  def version
    "#{self.major_version}.#{self.minor_version}.#{self.tiny_version}"
  end
end
