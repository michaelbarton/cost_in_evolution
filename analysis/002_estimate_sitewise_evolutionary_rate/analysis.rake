namespace '002' do

  desc 'Clears evolutionary rate data'
  task :clear_evo_rate_data do
    EvolutionaryRate.delete_all
  end

  desc 'Runs evolutionary rate analysis on alignments'
  task :estimate_gene_and_site_mutation_rates do
    starfish = %x|which starfish|.strip
    loader = PROJECT_ROOT + '/model/starfish/load_gene_site_rates.rb'
    p = lambda{ system( "qsub -cwd -j y -V #{starfish} #{loader}") }

    p.call
    sleep(120)
    16.times { p.call }
  end

end
