class Project < ActiveRecord::Base

  def html_summary
    BlueCloth.new(self.summary).to_html
  end

  def version
    "#{self.major_version}.#{self.minor_version}.#{self.tiny_version}"
  end
end
