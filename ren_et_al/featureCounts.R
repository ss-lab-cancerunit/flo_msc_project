#script to run featureCounts
#f.obote 24-03-2025

#download packages:
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("Rsubread")

#load packages:
library(Rsubread)

#bam files
bam_files <- list.files("/rds/general/user/fno124/ephemeral/rna_seq/Ren_BAM_3/", pattern = "\\.bam$", full.names = TRUE)

#featureCounts from the manual
Ren_featureCounts <- featureCounts(files=bam_files,
                isPairedEnd=TRUE,
                requireBothEndsMapped=TRUE,
                annot.ext="/rds/general/user/fno124/home/GENCODE_GENOME_INDEX/basic_gene_annotation_PRI.gtf",
                isGTFAnnotationFile=TRUE,GTF.featureType="exon",
                GTF.attrType="gene_id")

#convert output to a table to capture read counts
write.table(
  x=data.frame(Ren_featureCounts$annotation[,c("GeneID","Length")],
    Ren_featureCounts$counts,
    stringsAsFactors=FALSE),
  file="counts_1.txt",
  quote=FALSE,
  sep="\t",
  row.names=FALSE)
