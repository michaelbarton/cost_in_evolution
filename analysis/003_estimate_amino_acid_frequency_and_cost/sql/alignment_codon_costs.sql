SELECT
  genes.name AS gene,
  alignment_codons.start_position AS codon,
  conditions.abbrv AS condition_type,
  cost_types.abbrv AS cost_type,
  alignment_codon_costs.mean AS cost
FROM
  alignment_codon_costs
LEFT JOIN
  conditions ON alignment_codon_costs.condition_id = conditions.id
LEFT JOIN
  cost_types ON alignment_codon_costs.cost_type_id = cost_types.id
LEFT JOIN
  alignment_codons  ON alignment_codon_costs.alignment_codon_id = alignment_codons.id
LEFT JOIN
  alignments ON alignment_codons.alignment_id = alignments.id
LEFT JOIN
  genes ON alignments.gene_id = genes.id
