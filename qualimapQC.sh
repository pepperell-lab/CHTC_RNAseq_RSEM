#!/bin/bash
staging_prefix=/staging/groups/pepperell_group/Mtb_RNAseq/RSEM
results_staging_prefix=/staging/groups/pepperell_group/Mtb_RNAseq/RSEM/Results
multiqc_staging_prefix=/staging/groups/pepperell_group/Mtb_RNAseq/RSEM/Results/MultiQC

cp $results_staging_prefix/$1_Aligned.sortedByCoord.out.bam $staging_prefix/$2 ./

# gunzip -c $1.sort.bam.gz > $1.sort.bam
# run qualimap-bamqc
qualimap bamqc -bam $1_Aligned.sortedByCoord.out.bam -outdir $1_bamqc --java-mem-size=2G

# run qualimap-rnaseq
qualimap rnaseq -bam $1_Aligned.sortedByCoord.out.bam -outdir $1_rnaseq -pe -gtf $2 --java-mem-size=2G

tar -zcvf $1.qualimap.tar.gz $1_bamqc/ $1_rnaseq/

mv $1.qualimap.tar.gz $multiqc_staging_prefix/
