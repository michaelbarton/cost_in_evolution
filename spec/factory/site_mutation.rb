Factory.define :site_mutation do |f|
  f.alignment_codon_id do 
    codon = AlignmentCodon.find_by_start_position(99 * 3)
    raise RuntimeError, 'Required alignment codon not stored in the database' if codon.nil?
    codon.id
  end
  f.rate 1.779
end
