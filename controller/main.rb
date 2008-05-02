class MainController < Ramaze::Controller

  layout '/index'

  def index
    @project = Project.find(:all).first
  end
end
