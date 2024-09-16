#!/bin/zsh

query_file="data/HK_domain.faa"
for subject_file in data/*.fna; do
  species=$(basename "$subject_file" .fna)
  bed_file="data/${species}.bed"
  outfile="outputs/${species}_outfile.txt"
  ./find_homologs.sh $query_file $subject_file $bed_file $outfile
  number_of_genes=$(cat $outfile | wc -l)
  echo "Number of genes identified for $species: $number_of_genes"
done