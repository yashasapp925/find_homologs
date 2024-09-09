query_file="$1"
subject_file="$2"
output_file="$3"

tblastn -query "$query_file" -subject "$subject_file" -outfmt "6 qseqid sseqid pident length qlen" -out temp.txt
awk -v x=$query_length '$3 > 30 && $4 >= 0.9 * $5' temp.txt > "$output_file"
num_matches=$(wc -l < "$output_file")
echo "Number of matches: $num_matches"
rm temp.txt