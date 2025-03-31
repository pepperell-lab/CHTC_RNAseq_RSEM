#!/bin/bash

# Prompt user for folder name
read -p "Enter the folder name: " FOLDER

# Define paths
SOURCE_PATH="/staging/groups/pepperell_group/$FOLDER"
MULTIQC_PATH="/staging/groups/pepperell_group/Mtb_RNAseq/RSEM/Results/MultiQC"
OUTPUT_FILE="${MULTIQC_PATH}/${FOLDER}_multiqc_report.tar.gz"

# Ensure the source folder exists
if [[ ! -d "$SOURCE_PATH" ]]; then
    echo "Error: Folder $SOURCE_PATH does not exist."
    exit 1
fi

echo "Processing files in $SOURCE_PATH..."

# Temporary directory for archiving
TMP_DIR=$(mktemp -d)

# Flag to track any errors
error_flag=0

# Find all bases in the source path
bases=()
while IFS= read -r file; do
    bases+=("$(basename "$file" "_R1_001.fastq.gz")")
done < <(find "$SOURCE_PATH" -type f -name "*_R1_001.fastq.gz")

# Check if all bases exist in MultiQC and have all required files
for base in "${bases[@]}"; do
    R1_FILE="${MULTIQC_PATH}/${base}_R1_001_fastqc.zip"
    R2_FILE="${MULTIQC_PATH}/${base}_R2_001_fastqc.zip"
    P1_FILE="${MULTIQC_PATH}/${base}_1P_fastqc.zip"
    P2_FILE="${MULTIQC_PATH}/${base}_2P_fastqc.zip"
    QUALIMAP_FILE="${MULTIQC_PATH}/${base}.qualimap.tar.gz"

    # Check if all files exist
    missing_files=()
    for file in "$R1_FILE" "$R2_FILE" "$P1_FILE" "$P2_FILE" "$QUALIMAP_FILE"; do
        if [[ ! -f "$file" ]]; then
            missing_files+=("$file")
        fi
    done

    # If any file is missing, report an error
    if [[ ${#missing_files[@]} -gt 0 ]]; then
        echo "Error: Missing files for base $base:"
        for missing in "${missing_files[@]}"; do
            echo "  - $missing"
        done
        error_flag=1
        continue
    fi

    # Copy files to temporary directory for archiving
    cp "$R1_FILE" "$R2_FILE" "$P1_FILE" "$P2_FILE" "$QUALIMAP_FILE" "$TMP_DIR"
done

# If errors occurred, do not create the archive
if [[ $error_flag -eq 1 ]]; then
    echo "Some bases are missing files. Archive not created."
    rm -rf "$TMP_DIR"
    exit 1
fi

# Create the gzipped tar archive
tar -czf "$OUTPUT_FILE" -C "$TMP_DIR" .

# Cleanup temporary directory
rm -rf "$TMP_DIR"

echo "Archive created: $OUTPUT_FILE"

