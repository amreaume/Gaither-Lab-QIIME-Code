#!/bin/bash
#SBATCH -o /home/areaume/scripts/slurmout/slurm-%j.out # STDOUT
export LC_ALL="C.UTF-8"
module load qiime2/2024.2
source activate qiime2-amplicon-2024.2
qiime demux summarize \
   --i-data /home/areaume/REU/trimmed-samples.qza\
   --o-visualization /home/areaume/REU/trimmedQC