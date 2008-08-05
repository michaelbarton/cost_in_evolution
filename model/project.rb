class Project < ActiveRecord::Base

  def content
    BlueCloth.new(self.description).to_html
  end

  def summary
    self.content.split(/\n/).first.strip
  end

  def version
    "#{self.major_version}.#{self.minor_version}.#{self.tiny_version}"
  end
end
