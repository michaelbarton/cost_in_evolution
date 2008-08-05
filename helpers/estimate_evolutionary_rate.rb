class EstimateEvolutionaryRate

  def self.generate_alignment_file(alignment)
    tfile = Tempfile.new('alignment').path
    File.open(tfile, 'w') {|file| file.puts alignment.to_s}
    tfile
  end

  def self.generate_tree_file(alignment)
    tfile = Tempfile.new('tree').path
    File.open(tfile, 'w') {|file| file.puts alignment.tree}
    tfile
  end

end
