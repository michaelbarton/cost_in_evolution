class MainController < Ramaze::Controller

  layout :page => [:index,:milestone]

  def page
  end

  def index
    p = Project.all.first
    @version = p.version
    @summary = p.html_summary
  end

  def milestone(n = nil)
    unless n
      @list = true
      @title = "Project Milestones"
      @milestones = Milestone.all.sort
    else
      @list = false
      @milestone = Milestone.all(:number => n).first
      @title = "Project Milestone " + @milestone.number.to_s
    end
  end

  define_method 'css/style' do
  end

end
