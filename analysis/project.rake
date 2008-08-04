PROJECT_VERSION = '0.1.0'

namespace 'analysis' do

  Dir.glob('analysis/*/analysis.rake').each {|file| load file}

  desc 'Resets and rebuilds all the analyses'
  task :analysis_rebuild => [
    '001:analysis_rebuild',
    '002:analysis_rebuild'
  ]

end
