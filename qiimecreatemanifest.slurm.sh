#!/bin/bash
#SBATCH -o /home/areaume/scripts/slurmout/slurm-%j.out # STDOUT

# set the path to the directory containing the clean sequence files
input_dir="/home/areaume/REU/clean"

# set the path and filename for the output manifest file
output_manifest="/home/areaume/REU/manifest.txt"

# write the column headers to the manifest file
echo -e "sample-id\tforward-absolute-filepath\treverse-absolute-filepath" >> "$output_manifest"


# loop through the files in the input directory
for file in "$input_dir"/*_R1.fastq.gz; do
  # get the filename without the _R1.fastq.gz extension
  filename=$(basename "$file" _R1.fastq.gz)
  
  # get the sample ID from the filename
  sample_id=$(echo "$filename" | awk -F "_" '{print $1}')
  
  # set the absolute path to the forward input file
  forward_abs_path=$(readlink -f "$file")
  
  # set the absolute path to the reverse input file
  reverse_abs_path=$(readlink -f "$input_dir"/"${filename}"_R2.fastq.gz)
  
  # write the line to the manifest file
  echo -e "${sample_id}\t${forward_abs_path}\t${reverse_abs_path}" >> "$output_manifest"
done


###Partially written with ChatGPT