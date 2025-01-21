This repository contains code for processing REU Intern Stephanie's MiSeq run data from November 2024, it also serves as a tutorial for Gaither Lab members :) This repository will take you through downloading fastq files from BaseSpace to generating ASVs with taxonomic assignment. However, there are a lot of customizations that can be made in QIIME- optimize and edit your own code as necessary. 

QIIME code is modified from https://github.com/Joseph7e/HCGS_Metabarcoding_Tutorials 

# Getting Started:
All code should be run on Coombs. Most of the code is written in Slurm scripts; these files end in slurm.sh. 
To run these, copy your final slurm.sh file to Coombs. For example, in your own terminal run:
```python
scp qiimeexport.slurm.sh yourcoombsloginurl:/path/to/scripts/directory
```
Once the script is uploaded, execute it in Coombs:
```python
sbatch qiimeexport.slurm.sh
```

# Tutorial
## Step 1: 
Get files from BaseSpace using the code in the file *"DownloadingBaseSpace"*. <br/>
This code should be entered line by line into the terminal. By the end of this step, you will have fastq files from basespace saved into a directory called "raw".

## Step 2: 
Create a samples.txt file that lists the name of your fastq files for use in fastp: 
```python
ls -1 raw | sort -V > samples.txt
```
## Step 3: 
Perform QC on raw fastq files: run *fastp.slurm.sh*<br/>
This file needs to be run using an array- the script runs each time for each fastq file. Modify the array values to match the number of samples, and change the paths.

```python
sbatch --array=0-42 /path/to/fastp.slurm.sh /path/to/raw
```
This generates cleaned fastq files in a directory "clean" and fastp reports in "reports"

## Step 4:
Create a QIIME manifest: run *qiimecreatemanifest.slurm.sh* <br/>
This creates a .txt file that tells QIIME your sample names and cleaned fastq file locations

## Step 5: 
Import samples to QIIME: run *qiimeimport.slurm.sh*<br/>
This imports your samples to a .qza file called qiime-import.qza

## Step 6:
Remove primers: run *qiimeprimertrimming.slurm.sh*<br/>
Modify the following section of the script to match your primer sequences and their reverse compliments. 
```python
    --p-adapter-f GACGGGCGGTGTGTAC\ #forward reverse compliment
   --p-front-f GTACACACCGCCCGTC\ #forward primer
   --p-front-r TGATCCTTCTGCAGGTTCACCTAC\ #reverse primer
   --p-adapter-r GTAGGTGAACCTGCAGAAGGATCA\ #revese primer reverse compliment
```
## Step 7
Create a quality plot: run *qiimeQC.slurm.sh*</br>
This will create a quality plot called "trimmedQC.qzv". This file can be downloaded and viewed using the qiime viewer: https://view.qiime2.org/. We use the interactive quality plot to determine the truncation length for denoising in step 7. Truncation helps remove low quality basepairs at the ends of reads, and it also discards any reads shorter than your truncation length.</br>

Take this example from: https://forum.qiime2.org/t/nomenclature-issue-trimming-vs-truncation/21101/12 
>"take the following words as sequence examples:</br>
>QIIME2</br>
>TRIMMING</br>
>TRUNCATION</br>
> I will first truncate the above sequences with this command: trunc-len 7</br>
>This is what I will be left with:</br>
>TRIMMIN</br>
>TRUNCAT</br>
>Note that QIIME2 was dropped because it is shorter than the truncation of 7 that was specified."</br>

You also need at least 20nt of overlap. Our 18S v9 amplicon is 96-134bp, so we need the length of the reads to add up to at least 116-154. This won't be a problem here because we used 300 cycle kit. 

The quality plot for this dataset is saved in the file *trimmedQC.qzv*

## Step 8
This is where the magic happens! Denoising performs more QC, and generates "representative sequences" which are our ASVs in this case. Run: *qiimedenoise.slurm.sh*

As mentioned in step 6, we will have to customize our truncation parameters for this step. If you truncate too much, you won't have enough read length for merging. If you don't truncate enough, you loose shorter reads and retain lower quality basepairs that make merging reads difficult. 

For this dataset, I chose to truncate the reads to 100 bp both forward and backward. In this *dns.qzv* file you can view the denoising stats and see that 100-99.97% of our reads from the samples (not the blanks) passed filter. You may have to modify these parameters multiple times to choose the right truncation length.

This script also outputs the file *rep-seqs.qzv*. These are our ASVs.

## Step 8
Get a quick look at read/ASV coverage. Run: *qiimemetadatatabulate.slurm.sh*<br/>
This requires a .txt metadata file, it is almost identical to the one used to run the miseq. Ours is here and named *Metadata_Stephanie18S.txt*</br>

The ouput, *table.qzv* give us the number of features/ASVs (1,601) and the total frequency/reads (2,082,277). You can see how many reads are assigned to each sample as well.

## Step 9
Assign taxonomy to ASVs. Run: *qiimeassigntaxonomy.slurm.sh*

In this example I am using the PR2 reference database and the VSEARCH-based consensus taxonomy classifier. These options can be customized. 

This script starts by first importing the reference database .fasta and .tax files and converting them to .qza files. Next, it makes taxonomic assignments, which is saved as the .qza file *pr2-taxonomy.qza*. Finally, we generate a preliminary barplot *pr2-taxa-bar-plots.qzv* which can be viewed interactively with the QIIME viewer.

## Step 10
While there are many analyses that can be run in QIIME, I prefer to export my ASV and taxonomy tables here to analyze them futher in R. To export the files from .qza to .tsv files, run: *qiimeexport.slurm.sh*