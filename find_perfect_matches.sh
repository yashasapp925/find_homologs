#!/user/bin/env bash

query_file="$1"
subject_file="$2"
output_file="$3"

query_length=$(awk 'NR==2 {print length($0)}' $query_file)
blastn -query "$query_file" -subject "$subject_file" -outfmt "6 qseqid sseqid pident length" -out temp.txt
awk -v x=$query_length '$3 == 100 && $4 == x' temp.txt | awk '{print $0}' > "$output_file"
num_matches=$(wc -l < "$output_file")
echo "Number of perfect matches: $num_matches"
rm temp.txt