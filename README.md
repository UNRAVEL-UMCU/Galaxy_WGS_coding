![WGS coding analysis pipeline](https://github.com/UNRAVEL-UMCU/Galaxy_WGS_coding/assets/121402109/4a4adaf2-7dfa-470a-9dce-40969b938337)# Galaxy_WGS_coding 
## About
This study aims to identify coding DNA variants influencing phenotype variability among patients carrying the PLN R14del, focusing on gene expression differences in symptomatic and asymptomatic individuals. 

## Table of contents 
- [Workflow](#Workflow)
- [Requirements](#Requirements)
- [Data preparation](#Data-preparation)
- [Data analysis on local Galaxy](#Data-analysis-on-local-Galaxy)
- [Scripts](#Scripts)
- [Acknowledgments](#Acknowledgments)
## Workflow
![WGS coding analysis pipeline](https://github.com/UNRAVEL-UMCU/Galaxy_WGS_coding/assets/121402109/4988485a-0bee-4a94-950e-6e031851ab65)

## Requirements 
- Galaxy Europe
- Python 3.11.5
- R 4.3.1
- GRCh37

## Data preparation 
**Dataset Acquisition and Annotation:**
- **Source:** The [dataset](ftp://ftp.sra.ebi.ac.uk/vol1/ERZ389/ERZ389530/FR07961001.pass.recode.vcf.gz) was utilized from [Galaxy Europe](https://usegalaxy.eu). 
- **Annotation with dbSNP_GRCh37:** The dataset underwent annotation using the SnpSift Annotate tool, incorporating dbSNP_GRCh37 database information. This included INFO fields in the annotated file.
- **Further annotation with SnpEff eff:** Additional annotation was performed on the output from SnpSift Annotate using the SnpEff tool. "Homo sapiens: hg19" was selected as the reference genome for this purpose.

**Gene list compilation:**
- **Using Biomart:** A comprehensive list of 63737 genes was extracted using the Ensembl Biomart data mining tool. The extraction was based on the GRCh37.p13 reference genome with the attributes "Gene stable ID", "Gene stable ID version", "Transcript stable ID", "Transcript stable ID version", "Exon region start 
(bp)", "Exon region end (bp)", "Exon stable ID", "Gene type". 
- **Cardiac list:** Based on [Supplementary Table 7]([supplements/402792_file09.xlsx]) from [Pei et al. (2020)](https://www.biorxiv.org/content/10.1101/2020.11.30.402792v1.supplementary-material), cardiac-specific genes were divided into groups: all genes, all expressed genes, differentially expressed genes, upregulated, downregulated, diagnostic (21) genes and the PLN gene.

**Data integration and BED file generation:**
- **Dataset merging:** The gene list from Biomart and the categorized genes from Pei et al. were merged using Galaxy's 'Join two Datasets' tool, based on the "Gene stable ID" (ENSG_ID).
- **Filtering:** The merged dataset produced empty lines in the ENSG_ID column (column 12). These lines were filtered out using the 'Filter' tool with the condition " c12 != "" ".
- **BED file creation:** BED files were created by extracting the fields "Chromosome/scaffold name," "Exon region start (bp)," and "Exon region end (bp)". The files were uploaded on the local Galaxy environment, where the private data was analysed.

**Private data preparation:**
- **Data filtering:** Patient data was annotated with SnpSift Annotate and Snpeff tools before the upload on the private Galaxy environment. However, not all variants met the filtering criteria "PASS". To exclude low-quality variants, filtering using the 'Filter' tool and the condition " c7 == 'PASS' " was applied. The resulting files had to be further filtered with 'VCFfilter' to remove missing genotypes with the condition ! ( GT = . / . ) and the homozygous reference ! ( GT = 0 / 0 )  with the 'Inverts the filter' option activated. An additional step was required to eliminate empty lines that resulted from the 'VCFfilter' process. The final filtering ensured the datasets were ready for further analysis. 

## Data analysis on local Galaxy
- **Intersection:** An intersection analysis was conducted between the generated BED and filtered VCF files. This step was performed using the 'VCF-BEDintersect' tool available in the local Galaxy environment.
- **Annotation:** Annotation of the output from 'VCF-BEDintersect' was performed using the 'Snpeff' tool with default settings.
- **Reference SNP:** Each of the Reference SNP (rs) numbers represents a specific genetic variant. Some of the variants were unknown and/or unassigned. Using 'Filter', two files from each SNPeff output were generated, one containing only the known rs values, and one with the unknown values.
- **Allelic Observation (AO):** Allelic Observation (AO) was extracted from the 'SNPeff' files, by cutting the files, leaving only the 'GT:AD:DP:GQ:PL:PP' data. All variants that were considered homozygous reference ('0/0') and homozygous alternate ('1/1') were removed by implementing a custom R script.

## Scripts
Python and R scripts were used for visualization of the data in funnel charts, stacked bar charts and scatter plots. 

## Acknowledgments
Special acknowledgements to Magdalena Harakalova, Frank van Steenbeek, Tim van der Wiel, Esmee van Drie, Quinn Pistorius, Daan van Engelenhoven, Babette Janssen, Luka Hoeben, Jiayi Pei, Renee Maas, Michal Mokry, Folkert W Asselbergs, Anneline te Riele, Karin van Spaendonck-Zwarts, Pieter Doevendans, Pim van der Harst, Peter van Tintelen. 

The project was conducted at the Harakalova/v.Steenbeek research group, part of UMC Utrecht.  
