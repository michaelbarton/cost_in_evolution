PROJECT_VERSION = '0.1.0'

namespace 'analysis' do

  Dir.glob('analysis/*/analysis.rake').each {|file| load file}

  desc 'Loads the project summary'
  task 'set_summary' do
    Project.delete_all

    file = PROJECT_ROOT + '/analysis/description.markdown'

    File.open(file) do |f| 
      Project.create({
        :title         => f.readline.gsub(/#\s+/,''),
        :summary       => f.read,
        :major_version => PROJECT_VERSION.split('.')[0].to_i,
        :minor_version => PROJECT_VERSION.split('.')[1].to_i,
        :tiny_version  => PROJECT_VERSION.split('.')[2].to_i,
        :last_modified => Date.parse(File.mtime(file).to_s)
      })
    end
  end
  
  desc 'Resets and rebuilds all the analyses'
  task :analysis_rebuild => [
    '001:analysis_rebuild',
    '002:analysis_rebuild'
  ]

  desc 'Rebuilds website files'
  task :www_rebuild => [
    'set_summary',
    '001:www_rebuild'
  ]

end
