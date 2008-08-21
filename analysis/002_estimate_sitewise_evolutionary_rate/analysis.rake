namespace '002' do

  desc 'Clears gene mutation rate data'
  task :clear_estimated_gene_mutation_rate do
    GeneMutation.destroy_all "dataset = 'Barton2009'"
  end

  desc 'Clears site mutation rate data'
  task :clear_estimated_site_mutation_rate do
    SiteMutation.destroy_all
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
        :alignment_id    => align.id,
        :alpha           => er.gene_rate,
        :estimated_rate  => er.tree_length,
        :dataset         => 'Barton2009')
      SiteMutation.create_from_rates(er.site_rates,align)
    end
  end

  desc 'Clears all Wall2005 gene mutation rate data'
  task :clear_wall_data do
    GeneMutation.destroy_all "dataset = 'Wall2005'"
  end

  desc 'Loads Wall2005 evolutionary rate estimations'
  task :load_wall_rates do
    data = PROJECT_ROOT + "/data/wall_data.csv"
    FasterCSV.foreach(data, :headers => true) do |row|
      gene = Gene.find_by_name(row['ORF'])
      if gene
        alignment = gene.alignments.first
        if alignment
          GeneMutation.create(
	    :alignment_id   => alignment.id,
	    :alpha          => nil,
	    :estimated_rate => row['dS'].to_f,
	    :dataset        => 'Wall2005'
	 )
        end
      end
    end
  end

end
