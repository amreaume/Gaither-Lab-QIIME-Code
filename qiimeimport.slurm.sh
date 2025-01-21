#!/bin/bash
#SBATCH -o /home/areaume/scripts/slurmout/slurm-%j.out # STDOUT
export LC_ALL="C.UTF-8"
module load qiime2/2024.2
source activate qiime2-amplicon-2024.2
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path /home/areaume/REU/'manifest.txt' \
  --output-path /home/areaume/REU/qiime-import.qza \
  --input-format PairedEndFastqManifestPhred33V2