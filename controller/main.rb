class MainController < Ramaze::Controller

  engine :Haml

  def index
    @project = Project.find(:all).first
  end
end
