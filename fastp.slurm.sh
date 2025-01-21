#!/bin/bash  
#SBATCH -o /home/areaume/scripts/slurmout/slurm-%j.out # STDOUT

input_folder_path="$1"
# Read the input folder for file names
readarray -t samples < samples.txt
# Get every other file name (2 per sample)
index=$((${SLURM_ARRAY_TASK_ID} * 2))
echo "Index $index"
echo "${samples[@]}"
sample="${samples[$index]}"
# remove the read number from the sample names
sample="${sample%%_L001*}"
echo "$sample"

# Generate the file names for both reads
file_1=${input_folder_path}${sample}_L001_R1_001.fastq.gz
file_2=${input_folder_path}${sample}_L001_R2_001.fastq.gz

# Set some options for fastp
report_prefix=reports/${sample}
qualified_quality=30
unqual_percent=25
avg_quality=20
echo File 1: $file_1 File 2: $file_2
mkdir -p clean reports # make output directories

# Run fastp
fastp --in1 $file_1 --in2 $file_2 --out1 clean/${sample}_R1.fastq.gz --out2 clean/${sample}_R2.fastq.gz \
        --html ${report_prefix}_quality_fastp.html --report_title "${report_prefix} fastp report" \
        --qualified_quality_phred $qualified_quality --unqualified_percent_limit $unqual_percent \
        --average_qual $avg_quality --trim_poly_g --correction \
        --low_complexity_filter --detect_adapter_for_pe --overrepresentation_analysis   

echo Done!

