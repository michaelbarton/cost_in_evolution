SELECT
  genes.name AS gene,
  site_mutations.rate
FROM
genes
  RIGHT JOIN alignments ON alignments.gene_id = genes.id
  LEFT JOIN alignment_codons ON alignment_codons.alignment_id = alignments.id
  LEFT JOIN site_mutations ON site_mutations.alignment_codon_id = alignment_codons.id
WHERE alignment_codons.gaps = FALSE
