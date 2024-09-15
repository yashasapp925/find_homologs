query_file="$1"
subject_file="$2"
output_file="$3"
bed_file="$4"

tblastn -query "$query_file" -subject "$subject_file" -outfmt "6 qseqid sseqid pident length qlen sstart send" -out temp.txt
awk -v x=$query_length '$3 > 30 && $4 >= 0.9 * $5' temp.txt >> temp2.txt

while read -r line; do
    gene_start=$(echo "$line" | cut -f 2)
    gene_end=$(echo "$line" | cut -f 3)
    gene_name=$(echo "$line" | cut -f 4)
    while read -r line; do
        sstart=$(echo "$line" | cut -f 6)
        ssend=$(echo "$line" | cut -f 7)
        if [ "$sstart" -ge "$gene_start" ] && [ "$ssend" -le "$gene_end" ]; then
            echo $gene_name >> temp3.txt
        fi
    done < "temp2.txt"
done < "$bed_file"
sort -u temp3.txt >> "$output_file"
cat $output_file