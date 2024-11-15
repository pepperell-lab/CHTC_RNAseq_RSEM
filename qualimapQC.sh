#!/bin/bash
# gunzip -c $1.sort.bam.gz > $1.sort.bam
# run qualimap-bamqc
qualimap bamqc -bam $1.sort.bam  -outdir $1_bamqc --java-mem-size=2G

# run qualimap-rnaseq
qualimap rnaseq -bam $1.sort.bam -outdir $1_rnaseq -pe -gtf $2 --java-mem-size=2G

tar -zcvf $1.qualimap.tar.gz $1_bamqc/ $1_rnaseq/
