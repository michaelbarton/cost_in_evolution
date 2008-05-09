class MainController < Ramaze::Controller

  def index
    p = Project.all.first
    @title = p.title
    @summary = p.html_summary
    @version = p.version
  end

  def style
  end

end
