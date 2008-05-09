class Project < DataMapper::Base
  property :title,         :text
  property :summary,       :text
  property :last_modified, :datetime
  property :major_version, :integer
  property :minor_version, :integer
  property :tiny_version,  :integer

  def html_summary
    BlueCloth.new(self.summary).to_html
  end

  def version
    "#{self.major_version}.#{self.minor_version}.#{self.tiny_version}"
  end
end
