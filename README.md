# pepperell_lab_STAR_RSEM_Pipeline
Normalized count from the pipeline: Fastqc-Trim-Fastqc-STAR-RSEM

## Pipeline Visualization
![Pipeline Made by Kadee](./RNAseq_CHTC_Pipelines.png )

## Required Files

To run the pipeline, the following files are needed:

- **Reference File:** `MtbNCBIH37Rv.fa`
- **Adapter File:** `adapters.fa`
- **GTF File:** `MtbNCBIH37Rv_ncRNAs_sORFs.gtf`
- **Data Files:** Raw sequencing reads
  - `3151_19_S13_R1_001.fastq.gz`
  - `3151_19_S13_R2_001.fastq.gz`
- **Input File:** `input.txt` (contains sample identifiers, one per line)
    ```plaintext
    3151_17_S11
    3151_18_S12
    3151_19_S13
    ```
## DAG Files
The pipeline uses HTcondor DAG files to manage the workflow. These files are automatically generated and include:
- **Top-Level DAG File:** `input_TPM_topLevel.dag`
  - Runs individual DAG files for each sample.
  - Example DAG files for individual samples:
    - `3151_17_S11_TPM.dag`
    - `3151_18_S12_TPM.dag`
    - `3151_19_S13_TPM.dag`
- **Template and Script for DAG Generation:**
  - `TPM_dag.template`: Template DAG file with placeholders (`$(RUN)`, `$(REF)`, `$(annot_gtf)`) to be replaced.
  - `make_TPM_dag.py`: Script to generate individual DAG files by replacing placeholders with actual values.
- **Generating DAG Files:**
  - To generate the individual DAG files and top-level DAG file from the template, run the following command:
  ```bash
  python3 make_TPM_dag.py input.txt TPM_dag.template MtbNCBIH37Rv.fa MtbNCBIH37Rv_ncRNAs_sORFs.gtf
  ```
  
## Documentation: how to Build STAR/RSEM Dockerfile(Only if Docker image)
To create and build Docker images for STAR and RSEM, follow these steps. For more details, refer to the [CHTC Docker Build Guide](https://chtc.cs.wisc.edu/uw-research-computing/docker-build.html). Replace `<username>`, `<imagename>`, and `<tag>` with your DockerHub username, image name, and desired tag, respectively.

### Steps
1. **Create the Dockerfiles**  
   Create separate Dockerfiles for RSEM and STAR:
   - `RSEM.Dockerfile`
   - `STAR.Dockerfile`
2. **Build the Docker Images**  
   Use `docker buildx` to build the images with the appropriate platform.

   ```bash
   docker buildx build . -f RSEM.Dockerfile -t <username>/<imagename> --platform linux/x86_64
   # Example:
   docker buildx build . -f RSEM.Dockerfile -t marissazhang/rsem --platform linux/x86_64

   docker buildx build . -f STAR.Dockerfile -t <username>/<imagename> --platform linux/x86_64
   # Example:
   docker buildx build . -f STAR.Dockerfile -t marissazhang/star --platform linux/x86_64
   ```
3. **Push the Docker Images**

   ```bash
   docker push <username>/<imagename>:<tag>
   # Example:
   docker push marissazhang/rsem:latest
   docker push marissazhang/star:latest
   ```
## Reference
https://link.springer.com/protocol/10.1007/978-1-4939-4035-6_14
