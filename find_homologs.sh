#!/bin/zsh

query_file="$1"
subject_file="$2"
bed_file="$3"
output_file="$4"

tblastn -query "$query_file" -subject "$subject_file" -outfmt "6 qseqid sseqid pident length qlen sstart send" -out temp.txt
awk -v x=$query_length '$3 > 30 && $4 >= 0.9 * $5' temp.txt >> temp2.txt

while IFS=$'\t' read -r seqid gene_start gene_end gene_name score strand; do
    while IFS=$'\t' read -r qseqid sseqid pident length qlen sstart send; do
        if (( $sstart >= $gene_start && $send <= $gene_end )); then
            echo $gene_name >> temp3.txt
        fi
    done < "temp2.txt"
done < "$bed_file"
sort -u temp3.txt > "$output_file"
rm temp.txt
rm temp2.txt
rm temp3.txt