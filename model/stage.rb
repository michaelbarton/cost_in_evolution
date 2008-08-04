class Stage < ActiveRecord::Base
  include Comparable

  belongs_to :project

  def <=> other
     self.number <=> other.number
  end

  def content
    BlueCloth.new(self.description).to_html
  end

  def summary
    self.content.split(/\n/).first.strip
  end

  def self.create_from_markdown_erb(number,file)
    self.find_all_by_number(number).each {|r| r.destroy}
    File.open(file) do |f|
      return self.create({
        :number      => number,
        :title       => f.readline.gsub(/#+\s/,'').strip,
        :description => ERB.new(f.read.strip).result
      })
    end
  end

  def self.title
    'Project Stages'
  end

  def self.content
    Stage.all.sort.inject('') do |result, stage|
      result << "<h3>#{stage.title}</h3>"
      result << stage.summary
    end
  end

end

