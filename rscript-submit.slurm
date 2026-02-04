#!/bin/sh

#SBATCH --job-name=rscript-submit

# update the account and partition lines - use hyakalloc to find partitions you can use
# demo-only users remove account line (the next line)
#SBATCH --account=uwit 
#SBATCH --partition=compute 

#SBATCH --time=5:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=4G

#SBATCH --signal=USR2
#SBATCH --output=%x_%j.out

apptainer exec --bind /gscratch r-w-libs.sif Rscript test.R
