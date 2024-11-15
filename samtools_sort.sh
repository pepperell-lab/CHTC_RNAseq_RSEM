# gunzip -c $1.bam.gz > $1.bam
samtools sort -O bam -T $1.sort $1_Aligned.toTranscriptome.out.bam -o $1.sort.bam
#gzip $1.sort.bam 