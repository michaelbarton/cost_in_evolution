class MainController < Ramaze::Controller

  engine :Haml

  def index
    p = Project.all.first
    @title = p.title
    @summary = BlueCloth.new(p.summary).to_html
    @version = p.version
  end
end
