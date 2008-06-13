class MainController < Ramaze::Controller

  layout :page => [:index,:stage]

  def page
  end

  def version
    Project.all.first.version
  end

  def index
    p = Project.all.first
    @version = p.version
    @summary = p.html_summary
  end

  def stage(n = nil)
    unless n
      @list = true
      @title = "Project Stage"
      @stages = Stage.all.sort
    else
      @list = false
      @stage = Stage.all(:number => n).first
      @title = "Project Stage " + @stage.number.to_s
    end
  end

  define_method 'css/style' do
  end

end
