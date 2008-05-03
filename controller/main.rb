class MainController < Ramaze::Controller

  engine :Haml

  def index
    p = Project.all.first
    @title = p.title
    @summary = p.summary
    @version = p.version
  end
end
