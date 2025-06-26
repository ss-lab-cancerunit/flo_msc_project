#this script was submitted to the HPC to run featureCounts

#download packages:
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("Rsubread", force = TRUE)
install.packages("dplyr", repos="https://cloud.r-project.org/")

#load packages:
library(Rsubread)
library(dplyr)


#bam files
bam_files <- list.files("/rds/general/user/fno124/ephemeral/rna_seq/mcd_et_al_2017/mcd_bam/", pattern = "\\.bam$", full.names = TRUE)

#featureCounts code (see Rsubread manual)
featureCounts_mcd <- featureCounts(files=bam_files,
                isPairedEnd=TRUE,
                requireBothEndsMapped=TRUE,
                annot.ext="/rds/general/user/fno124/home/GENCODE_GENOME_INDEX_100bp/basic_gene_annotation_PRI.gtf",
                isGTFAnnotationFile=TRUE,
                GTF.featureType="exon",
                primaryOnly=TRUE,
                GTF.attrType="gene_id")



#creating RData file
file <- file.create("/rds/general/user/fno124/home/rna_seq/mcd_et_al_2017/mcd_featureCounts.RData")
save(featureCounts_mcd, file = "/rds/general/user/fno124/home/rna_seq/mcd_et_al_2017/mcd_featureCounts.RData")

#create csv file
rawCounts <- data.frame(featureCounts_mcd$counts) %>% rownames_to_column(var = "geneID")
write.csv(rawCounts, file = "/rds/general/user/fno124/home/rna_seq/mcd_et_al_2017/mcd_featureCounts.csv", rowNames=FALSE)
