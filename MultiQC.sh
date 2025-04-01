#!/bin/bash
results_staging_prefix=/staging/groups/pepperell_group/Mtb_RNAseq/RSEM/Results/MultiQC
cp $results_staging_prefix/MultiQC.tar.gz ./

echo "tar multiQC ..."
tar -xf MultiQC.tar.gz

echo "tar qualimap ..."
for f in *qualimap.tar.gz; do tar -xf $f; done

echo "running multiqc..."
multiqc -ds .

mv multiqc_report.html multiqc_data/
mv multiqc_data/ multiqc-report
tar -czvf multiqc-report.tar.gz multiqc-report/
mv multiqc-report.tar.gz ../
