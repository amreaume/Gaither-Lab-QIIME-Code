#!/bin/bash
#SBATCH -o /home/areaume/scripts/slurmout/slurm-%j.out # STDOUT
#SBATCH --cpus-per-task=20
export LC_ALL="C.UTF-8"
module load qiime2/2024.2
source activate qiime2-amplicon-2024.2
qiime dada2 denoise-paired\
   --i-demultiplexed-seqs /home/areaume/REU/trimmed-samples.qza\
   --p-trunc-len-f 100 --p-trunc-len-r 100\
   --p-n-threads 18\
   --o-denoising-stats /home/areaume/REU/dns\
   --o-table /home/areaume/REU/table\
   --o-representative-sequences /home/areaume/REU/rep-seqs\
   --verbose
qiime metadata tabulate\
   --m-input-file /home/areaume/REU/dns.qza\
   --o-visualization /home/areaume/REU/dns\
   --verbose
qiime feature-table tabulate-seqs\
   --i-data /home/areaume/REU/rep-seqs.qza\
   --o-visualization /home/areaume/REU/rep-seqs\
   --verbose

## run as sbatch --mem-per-cpu=32G