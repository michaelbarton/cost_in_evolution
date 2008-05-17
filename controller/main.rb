class MainController < Ramaze::Controller

  layout :page => [:index]

  def page
  end

  def index
    p = Project.all.first
    @title = p.title
    @summary = p.html_summary
    @version = p.version
    @milestones = Milestone.all.sort { |a,b| a.number <=> b.number }
  end

  define_method 'css/style' do
  end

end
