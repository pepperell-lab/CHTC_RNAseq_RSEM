#!/bin/bash

staging_prefix=/staging/groups/pepperell_group/Mtb_RNAseq/RSEM
results_staging_prefix=/staging/groups/pepperell_group/Mtb_RNAseq/RSEM/Results
multiqc_staging_prefix=/staging/groups/pepperell_group/Mtb_RNAseq/RSEM/Results/MultiQC
cp $staging_prefix/$2 $staging_prefix/$3 $results_staging_prefix/$1_Aligned.toTranscriptome.out.bam ./

# Note: Shell variables assignment cannot have space
BAM=$1_Aligned.toTranscriptome.out.bam
GENOME=$2
ANNOTATION=$3
RSEMgenomeDir=rsem
threads=8
nThreadsRSEM=8

# Replace the space in gtf file with underline
python3 clear_space.py $ANNOTATION

# RSEM, require Aligned.toTranscriptome.out.bam file
mkdir $RSEMgenomeDir
rsem-prepare-reference --gtf $ANNOTATION $GENOME $RSEMgenomeDir/RSEMref
# Last argument is the prefix of output file
rsem-calculate-expression --bam --no-bam-output --estimate-rspd \
                        --calc-ci --seed 12345 -p $nThreadsRSEM --ci-memory 30000 --paired-end \
                        --forward-prob 0 $BAM $RSEMgenomeDir/RSEMref $1

mv $1.isoforms.results $results_staging_prefix/