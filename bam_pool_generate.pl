#/usr/bin/perl

use strict;

open (OFH, ">pipeline_pool.sh");

print OFH "#!/bin/bash\n\n";


print OFH "#\$ -S /bin/bash\n";
print OFH "#\$ -l rmem=40G\n";
print OFH "#\$ -m bea\n";
print OFH "#\$ -M matthew.parker\@sheffield.ac.uk\n";
print OFH "#\$ -l h_rt=12:00:00\n";
print OFH "#\$ -o pool_mapping.out\n";
print OFH "#\$ -e pool_mapping.err\n";
print OFH "#\$ -N pool\n";

print OFH "#\$ -pe openmp 12\n\n";

print OFH "module load apps/bwa/0.7.17/gcc-6.2\n";

print OFH "module load apps/SAMtools/1.7/gcc-4.9.4\n";

print OFH "module load apps/java/jdk1.8.0_102/binary\n\n";

print OFH "bwa mem -M -t 12 /shared/bioinformatics_core1/Shared/cox/cnv/GENOME/Homo_sapiens.GRCh38.dna.chromosome_index /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool_R1.fq.gz /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool_R2.fq.gz > /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.sam\n\n";

print OFH "samtools view -Sb /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.sam > /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.bam\n\n";

print OFH "samtools sort /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.bam > /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.sorted.bam\n\n";

print OFH "java -Xmx2g -jar /home/md1mpar/wc/picard-2.18.10/picard.jar MarkDuplicates I=/shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.sorted.bam O=/shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.sorted.dups.bam M=/shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.dups.metrics\n\n";

print OFH "samtools rmdup /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.sorted.dups.bam /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.sorted.nodups.bam\n\n";

print OFH "samtools view -b -q 37 /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.sorted.nodups.bam > /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.sorted.final.bam\n\n";

print OFH "samtools view -F 0x40 /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.sorted.final.bam | cut -f1 | sort | uniq | wc -l > /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.adjusted_counts\n\n";

# print OFH "module load apps/R\n\n";

print OFH "java -Xmx2g -jar /home/md1mpar/wc/picard-2.18.10/picard.jar CollectInsertSizeMetrics I=/shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.sorted.final.bam O=/shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.inserts H=/shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.hist\n\n";

print OFH "samtools flagstat /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.sorted.final.bam > /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.counts\n\n";

print OFH "java -Xmx2g -jar /home/md1mpar/wc/picard-2.18.10/picard.jar CollectWgsMetrics I=/shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.sorted.final.bam O=/shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.cov R=/shared/bioinformatics_core1/Shared/cox/cnv/GENOME/Homo_sapiens.GRCh38.dna.chromosome_index.fa.gz\n\n";

print OFH "wc -l /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool/R1.fq > /shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.all_counts\n\n";
 
close OFH;

# system "qsub pipeline_pool.sh";

