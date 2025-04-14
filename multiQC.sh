#!/bin/bash
GROUP="$1"
cp /staging/groups/pepperell_group/Mtb_RNAseq/RSEM/Results/MultiQC/${GROUP}_multiqc_report.tar.gz ./

echo "tar multiQC ..."
tar -xf ${GROUP}_multiqc_report.tar.gz

echo "tar qualimap ..."
for f in *qualimap.tar.gz; do tar -xf $f; done

echo "running multiqc..."
multiqc -ds .

mv multiqc_report.html multiqc_data/
mv multiqc_data/ multiqc-report
mv multiqc-report ${GROUP}-RSEM-multiqc-report
tar -czvf ${GROUP}-RSEM-multiqc-report.tar.gz ${GROUP}-RSEM-multiqc-report/