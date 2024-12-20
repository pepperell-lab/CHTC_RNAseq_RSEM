#!/bin/bash

# Loop through all files ending with _1.fastq.gz
for file in *_1.fastq.gz; do
    base=$(basename "$file" _1.fastq.gz)
    # Rename the file to *_R1_001.fastq.gz
    mv "$file" "${base}_R1_001.fastq.gz"
done

# Loop through all files ending with _2.fastq.gz
for file in *_2.fastq.gz; do
    base=$(basename "$file" _2.fastq.gz)
    # Rename the file to *_R2_001.fastq.gz
    mv "$file" "${base}_R2_001.fastq.gz"
done
