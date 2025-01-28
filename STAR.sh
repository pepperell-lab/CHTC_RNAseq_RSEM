#!/bin/bash
staging_prefix=/staging/groups/pepperell_group/Mtb_RNAseq/RSEM
results_staging_prefix=/staging/groups/pepperell_group/Mtb_RNAseq/RSEM/Results

cp $results_staging_prefix/$1_1P.fq.gz $results_staging_prefix/$1_2P.fq.gz $staging_prefix/$2 $staging_prefix/$3 ./

# Note: Shell variables assignment cannot have space
# Input files are output files of trim
read1=$1_1P.fq.gz
read2=$1_2P.fq.gz
GENOME=$2
ANNOTATION=$3
STARgenomeDir=star
threads=8
nThreadsSTAR=8

# Replace the space in gtf file with underline
python3 clear_space.py $ANNOTATION

# STAR
mkdir $STARgenomeDir
STAR --runThreadN $threads --runMode genomeGenerate \
                        --genomeDir $STARgenomeDir --genomeFastaFiles $GENOME \
                        --sjdbGTFfile $ANNOTATION --sjdbOverhang 100 \
                        --outFileNamePrefix $STARgenomeDir --genomeSAindexNbases 10
# --outFileNamePrefix makes Aligned.toTranscriptome.out.bam to $(RUN)_Aligned.toTranscriptome.out.bam
STAR --genomeDir $STARgenomeDir --readFilesIn $read1 $read2 \
                        --readFilesCommand zcat --outFilterType BySJout --outSAMunmapped Within \
                        --outSAMtype BAM SortedByCoordinate --outSAMattrIHstart 0 \
                        --outFilterIntronMotifs RemoveNoncanonical --runThreadN $nThreadsSTAR \
                        --quantMode TranscriptomeSAM --outWigType bedGraph --outWigStrand Stranded \
                        --limitBAMsortRAM 1207111982  --outFileNamePrefix $1_

mv $1_Aligned.toTranscriptome.out.bam $results_staging_prefix/
mv $1_Aligned.sortedByCoord.out.bam $results_staging_prefix/

rm $results_staging_prefix/$1_1P.fq.gz $results_staging_prefix/$1_2P.fq.gz $staging_prefix/$2 $staging_prefix/$3