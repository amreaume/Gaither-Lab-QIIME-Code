#!/bin/bash
#SBATCH -o /home/areaume/scripts/slurmout/slurm-%j.out # STDOUT
export LC_ALL="C.UTF-8"
module load qiime2/2024.2
source activate qiime2-amplicon-2024.2
qiime cutadapt trim-paired\
  --i-demultiplexed-sequences /home/areaume/REU/qiime-import.qza \
   --p-adapter-f GACGGGCGGTGTGTAC\
   --p-front-f GTACACACCGCCCGTC\
   --p-front-r TGATCCTTCTGCAGGTTCACCTAC\
   --p-adapter-r GTAGGTGAACCTGCAGAAGGATCA\
   --o-trimmed-sequences trimmed-samples.qza\
   --verbose

##source code found at https://forum.qiime2.org/t/cutadapt-adapter-vs-front/15450/2
