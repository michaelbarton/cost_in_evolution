PROJECT_VERSION = '0.0.1'

namespace 'analysis' do

  desc 'Loads the project summary'
  task 'set_summary' do
    Project.delete_all

    file = File.dirname(__FILE__) + '/description.txt'

    File.open(file) do |f| 
      Project.create({
        :title         => f.readline.gsub(/#\s+/,''),
        :summary       => f.read,
        :major_version => PROJECT_VERSION.split('.')[0],
        :minor_version => PROJECT_VERSION.split('.')[1],
        :tiny_version  => PROJECT_VERSION.split('.')[2],
        :last_modified => Date.parse(File.mtime(file).to_s)
      })
    end
  end
  
end
