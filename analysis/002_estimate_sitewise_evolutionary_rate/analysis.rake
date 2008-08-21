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

  desc 'Calculates evolutionary rate for any alignments that do have an evolutionary rate record'
  task :estimate_missing_rates do
    all = Alignment.all(:include => :gene_mutations)
    missing = all.select{|x| x.gene_mutations.length == 0}

    missing.each do |align|
      er = EvolutionaryRate.new(align).run
      GeneMutation.create(
        :alignment_id => align.id,
        :rate         => er.gene_rate,
        :tree_length  => er.tree_length,
        :dataset      => 'Barton2009')
      SiteMutation.create_from_rates(er.site_rates,align)
    end
  end

end
