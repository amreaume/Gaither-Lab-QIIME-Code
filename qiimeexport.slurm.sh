#!/bin/bash
#SBATCH -o /home/areaume/scripts/slurmout/slurm-%j.out # STDOUT
export LC_ALL="C.UTF-8"
module load qiime2/2024.2
source activate qiime2-amplicon-2024.2
qiime tools export\
    --input-path /home/areaume/REU/table.qza\
    --output-path /home/areaume/REU/export/table
biom convert -i /home/areaume/REU/export/table/feature-table.biom -o /home/areaume/REU/export/table/feature-table.tsv --to-tsv

qiime tools export\
    --input-path /home/areaume/REU/pr2-taxonomy.qza\
    --output-path /home/areaume/REU/export/pr2-taxonomy.qza
