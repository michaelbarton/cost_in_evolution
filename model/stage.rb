class Stage
  include DataMapper::Resource
  include Comparable

  property :id,          Integer,  :serial => true
  property :number,      Integer
  property :title,       Text
  property :description, Text

  belongs_to :project

  def <=> other
     self.number <=> other.number
  end

  def html_description
    BlueCloth.new(self.description).to_html
  end

  def html_summary
    self.html_description.split(/\n/).first.strip
  end

  def self.create_from_markdown_erb(number,file)
    self.all(:number => number).each {|r| r.destroy!}
    File.open(file) do |f|
      return self.create({
        :number      => number,
        :title       => f.readline.gsub(/#+\s/,'').strip,
        :description => ERB.new(f.read.strip).result
      })
    end
  end

end
