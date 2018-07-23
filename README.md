# cox_ctdna_cnv
low coverage whole genome cancer ctDNA copy number pipeline


Shobha data processing pipeline

Pre-preparation of files

Each sample is associated with 1 directory and 4 files – 
5’ reads, Lane 1
3’ reads, Lane 1
5’ reads, Lane 2
3’ reads, Lane 2

1.	For easier handling in later stages of pipeline, rename directories to follow this convention: 
[CTG]xxxx_CNVy where C = plasma, T = tumour, G = genomic, xxxx =patient ID, y = batch number.
e.g. T0046_CNV3 = tumour sample from patient 46 run in CNV3.

2.	Unzip the .gz fastq files
> gunzip [PATH]/[file_id].fastq.gz

3.	Concatenate files from Lane 1 and Lane 2 i.e. 5’ reads, Lane 1 + 5’ reads, Lane 2, and 3’ reads, Lane 1 + 3’ reads, Lane 2
> cat [PATH]/[file_id]_L001_R1.fastq [PATH]/[file_id]_L002_R1.fastq > [PATH]/R1.fq
> cat [PATH]/[file_id]_L001_R2.fastq [PATH]/[file_id]_L002_R2.fastq > [PATH]/R2.fq

4.	Create a Samples.txt file containing list of samples (1 per line) run in the batch, e.g.
C0009_CNV4
C0013_CNV4
C0015_CNV4
C0016_CNV4
C0018_CNV4 
etc…

BAM file generation

BAM files are generated using the PERL script bam_generate.pl.  

Hardware requirements:

Iceberg (relies on job management system, and access to /fastdata storage area) 

Software requirements:

bwa
samtools
picard-tools
bam_generate.pl
bam_generate_hg19.pl

File requirements:

Fastq files prepared as above
Samples.txt
bwa indexed human genome

Recommendations:

Set up a directory in /fastdata/[your_username] named SHOBHA.  This should contain all sample directories + the following additional directories:

BAMS
HG19_BAMS
FIXED_WINDOWS
WINDOWS
HG19_METRICS
METRICS                         

Now run bam_generate.pl from the same directory containing Samples.txt.  This will create and run one shell script per sample containing following commands:

# Map reads to human genome using BWA
> [PATH_TO_BWA]/bwa mem -M -t 6 [PATH_TO_HUMAN_GENOME]/Homo_sapiens.GRCh38.dna.chromosome_index /fastdata/[USERNAME]/SHOBHA/[SAMPLE_ID]/R1.fq /fastdata/[USERNAME]/SHOBHA/[SAMPLE_ID]/R2.fq > /fastdata/[USERNAME]/SHOBHA/BAMS/[SAMPLE_ID].sam

# Convert SAM output to BAM
> [PATH_TO_SAMTOOLS]/samtools view -Sb /fastdata/[USERNAME]/SHOBHA/BAMS/[SAMPLE_ID].sam > /fastdata/[USERNAME]/SHOBHA/BAMS/[SAMPLE_ID].bam

# Sort BAM file
> /home/md1jrbx/Software/samtools-0.1.19/samtools sort /fastdata/[USERNAME]/SHOBHA/BAMS/[SAMPLE_ID].bam /fastdata/[USERNAME]/SHOBHA/BAMS/[SAMPLE_ID].sorted.bam

# Mark duplicates
> java -Xmx2g -jar /home/[USERNAME]/[PATH_TO_PICARD]/MarkDuplicates.jar I=/fastdata/[USERNAME]/SHOBHA/BAMS/[SAMPLE_ID].sorted.bam.bam O=/fastdata/[USERNAME]/SHOBHA/BAMS/[SAMPLE_ID].sorted.dups.bam M=/fastdata/[USERNAME]/SHOBHA/METRICS/[SAMPLE_ID].dups.metrics

# Remove duplicates
> [PATH_TO_SAMTOOLS]/samtools rmdup /fastdata/[USERNAME]/SHOBHA/BAMS/[SAMPLE_ID].sorted.dups.bam /fastdata/[USERNAME]/SHOBHA/BAMS/[SAMPLE_ID].sorted.nodups.bam

# Remove reads with mapping quality < 37
> [PATH_TO_SAMTOOLS]samtools-0.1.19/samtools view -b -q 37 /fastdata/[USERNAME]/SHOBHA/BAMS/[SAMPLE_ID].sorted.nodups.bam > /fastdata/[USERNAME]/SHOBHA/BAMS/[SAMPLE_ID].sorted.final.bam

# Count number of mapped reads
> /home/[USERNAME]/[PATH_TO_SAMTOOLS]/samtools view -F 0x40 /fastdata/[USERNAME]/SHOBHA/BAMS/[SAMPLE_ID].sorted.final.bam | cut -f1 | sort | uniq | wc -l > /fastdata/[USERNAME]/SHOBHA/METRICS/[SAMPLE_ID].adjusted_counts

# Calculate insert sizes
> java -Xmx2g -jar [PATH_TO_PICARD]/CollectInsertSizeMetrics.jar I=/fastdata/[USERNAME]/SHOBHA/BAMS/[SAMPLE_ID].sorted.final.bam O=/fastdata/[USERNAME]/SHOBHA/METRICS/[SAMPLE_ID].inserts H=/fastdata/[USERNAME]/SHOBHA/METRICS/[SAMPLE_ID].hist

# Calculate coverage statistics
> java -Xmx2g -jar [PATH_TO_PICARD]/CollectWgsMetrics.jar I=/fastdata/[USERNAME]/SHOBHA/BAMS/[SAMPLE_ID].sorted.final.bam O=/fastdata/[USERNAME]/SHOBHA/METRICS/[SAMPLE_ID].cov R=[PATH_TO_HUMAN_GENOME]/Homo_sapiens.GRCh38.dna.chromosome_index.fa

# Calculate coverage statistics
> wc -l /fastdata/[USERNAME]/SHOBHA/[SAMPLE_ID]/R1.fq > /fastdata/[USERNAME]/SHOBHA/METRICS/[SAMPLE_ID].all_counts

Notes:

•	This pipeline will generate output appropriate for CNANORM.   To generate BAM files compatible with QDNASEQ (i.e. mapped against hg19), use bam_generate_hg19.pl.  

•	Each of the metric outputs can be processed into a friendlier tab-delimited file using process_metrics.pl (or process_metrics_hg19.pl for hg19 output). 

Generate windows for CNANORM

Windows are generated using the PERL script window_generate.pl.

Hardware requirements:

Iceberg (relies on job management system, and access to /fastdata storage area)
TMP directory located in /fastdata/[USERNAME]

Software requirements

bam2windows.pl: packaged with CNANORM, uses bam file as input to generate window files.
clean_tab.pl: removes a blacklist of regions 

File requirements:

Sample_Pairs.txt (format: Sample ID of test[TAB]Sample ID of control[TAB]Name of output - use sample ID of test) e.g.

C0009_CNV4	G0009_CNV4	C0009_CNV4
C0013_CNV4	G0013_CNV4	C0013_CNV4
C0015_CNV4	G0015_CNV4	C0015_CNV4
C0016_CNV4	G0016_CNV4	C0016_CNV4
C0018_CNV4	G0018_CNV4	C0018_CNV4
C0024_CNV4	G0024_CNV4	C0024_CNV4
etc…

gc1000base_38.txt: GC content in windows of 1000 bases length across the genome.
BAM files as generated by bam_generate.pl.
Excluded_Regions.bed: coordinates of blacklisted regions deemed unreliable for mapping short reads.

Now run window_generate.pl from the same directory containing Sample_Pairs.txt.  This will create and run one shell script per sample containing following commands:

#Calculate read counts across test and control samples segmented into windows of length x bases where average read count across windows in test sample = 1000.
> perl /home/md1jrbx/Shobha/bam2windows.pl --samtools-path /home/md1jrbx/Software/samtools-0.1.19/samtools -ts -cs -d /fastdata/md1jrbx/TMP -r 1000 -gc /home/md1jrbx/Shobha/gc1000base_38.txt /fastdata/[USERNAME]/SHOBHA/BAMS/TEST_ID.sorted.final.bam /fastdata/[USERNAME]/SHOBHA/BAMS/CONTROL_ID.sorted.final.bam > /fastdata/[USERNAME]/SHOBHA/WINDOWS/[TEST_ID].tab

#Remove blacklisted regions
> perl /home/md1jrbx/Shobha/clean_tab.pl [TEST_ID] 

The alternative script, window_fixed_generate.pl also needs to be run (which requires clean_tab_fixed.pl).  This will calculate read counts across test and control samples segmented into windows of length 1000,000 bases.

Run CNANORM

Hardware requirements:

Desktop computer

Software requirements:

R
CNAnorm Bioconductor package + dependencies
CNAnorm_closest.R
CNAnorm_density.R

File requirements:

All files generated from window generation step in WINDOWS and FIXED_WINDOWS directories.
Sample_Pairs.txt

Recommendations:

Create new directories for separate output types:

ALL_WINDOWS_1000_CLOSEST
ALL_WINDOWS_1000_DENSITY
ALL_WINDOWS_FIXED_CLOSEST
ALL_WINDOWS_FIXED_DENSITY
CLEANED_WINDOWS_1000_CLOSEST
CLEANED_WINDOWS_1000_DENSITY
CLEANED_WINDOWS_FIXED_CLOSEST
CLEANED_WINDOWS_FIXED_DENSITY

Simply running the PERL script CNAnorm_generate.pl will invoke CNAnorm and generate all output files for every window and normalisation combination.
