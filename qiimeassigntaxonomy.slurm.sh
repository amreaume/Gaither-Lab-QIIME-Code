#!/bin/bash
#SBATCH -o /home/areaume/scripts/slurmout/slurm-%j.out # STDOUT
#SBATCH --cpus-per-task=20
export LC_ALL="C.UTF-8"
module load qiime2/2024.2
source activate qiime2-amplicon-2024.2
##code partially from https://github.com/allenlab/QIIME2_18Sv9_ASV_protocol
##import pr2 to qiime format
qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path /home/areaume/pr2/pr2_version_5.0.0_SSU_mothur.fasta  \
  --output-path /home/areaume/pr2/pr2_version_5.0.0.qza

qiime tools import \
  --type 'FeatureData[Taxonomy]' \
  --input-format HeaderlessTSVTaxonomyFormat \
  --input-path /home/areaume/pr2/pr2_version_5.0.0_SSU_mothur.tax \
  --output-path /home/areaume/pr2/pr2_version_5.0.0_tax.qza

#assigntaxonomy
qiime feature-classifier classify-consensus-vsearch\
   --i-query /home/areaume/REU/rep-seqs.qza\
   --i-reference-reads /home/areaume/pr2/pr2_version_5.0.0.qza\
   --i-reference-taxonomy /home/areaume/pr2/pr2_version_5.0.0_tax.qza\
   --p-maxaccepts 5 --p-query-cov 0.4\
   --p-perc-identity 0.7\
   --o-classification /home/areaume/REU/pr2-taxonomy\
   --o-search-results /home/areaume/REU/pr2-searchresults\
   --p-threads 72\
   --verbose
qiime taxa barplot \
    --i-table /home/areaume/REU/table.qza \
    --i-taxonomy /home/areaume/REU/pr2-taxonomy.qza \
    --m-metadata-file /home/areaume/REU/Metadata_Stephanie18S.txt\
    --o-visualization /home/areaume/REU/pr2-taxa-bar-plots.qzv\
    --verbose
