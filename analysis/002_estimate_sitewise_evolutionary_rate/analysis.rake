namespace '002' do

  @number = 1  

  desc 'Clears evolutionary rate data'
  task :clear_evo_rate_data do
    EvolutionaryRate.delete_all
  end

  desc 'Runs evolutionary rate analysis on alignments'
  task :estimate_evolutionary_rate do
    Alignment.all.each do |alignment|
      EvolutionaryRate.codeml_estimate_rate(alignment)
    end
  end

end
