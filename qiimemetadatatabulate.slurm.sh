#!/bin/bash
#SBATCH -o /home/areaume/scripts/slurmout/slurm-%j.out # STDOUT
export LC_ALL="C.UTF-8"
module load qiime2/2024.2
source activate qiime2-amplicon-2024.2
qiime feature-table summarize\
   --i-table /home/areaume/REU/table.qza\
   --m-sample-metadata-file /home/areaume/REU/Metadata_Stephanie18S.txt\
   --o-visualization table\
   --verbose
