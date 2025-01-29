#!/bin/bash
staging_prefix=/staging/groups/pepperell_group/Mtb_RNAseq/RSEM
multiqc_staging_prefix=/staging/groups/pepperell_group/Mtb_RNAseq/RSEM/Results/MultiQC

cp $staging_prefix/$1_R1_001.fastq.gz $staging_prefix/$1_R2_001.fastq.gz ./
fastqc $1_R1_001.fastq.gz $1_R2_001.fastq.gz -t 4

mv $1_R1_001_fastqc.zip $multiqc_staging_prefix/
mv $1_R2_001_fastqc.zip $multiqc_staging_prefix/