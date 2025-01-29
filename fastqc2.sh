#!/bin/bash
results_staging_prefix=/staging/groups/pepperell_group/Mtb_RNAseq/RSEM/Results
multiqc_staging_prefix=/staging/groups/pepperell_group/Mtb_RNAseq/RSEM/Results/MultiQC

cp $results_staging_prefix/$1_1P.fq.gz $results_staging_prefix/$1_2P.fq.gz ./
fastqc $1_1P.fq.gz $1_2P.fq.gz -t 4

mv $1_1P_fastqc.zip $multiqc_staging_prefix/
mv $1_2P_fastqc.zip $multiqc_staging_prefix/