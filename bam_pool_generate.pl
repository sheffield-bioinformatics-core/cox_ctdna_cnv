#/usr/bin/perl

use strict;

open (OFH, ">pipeline_pool.sh");

print OFH "#!/bin/bash\n\n#\$ -pe openmp 6\n\n";

print OFH "/home/md1jrbx/Software/bwa-0.7.10/bwa mem -M -t 6 /fastdata/md1jrbx/HUMAN_GENOME/Homo_sapiens.GRCh38.dna.chromosome_index /fastdata/md1jrbx/SHOBHA/Pool_R1.fq /fastdata/md1jrbx/SHOBHA/Pool_R2.fq > /fastdata/md1jrbx/SHOBHA/BAMS/Pool.sam\n";

print OFH "/home/md1jrbx/Software/samtools-0.1.19/samtools view -Sb /fastdata/md1jrbx/SHOBHA/BAMS/Pool.sam > /fastdata/md1jrbx/SHOBHA/BAMS/Pool.bam\n";

print OFH "/home/md1jrbx/Software/samtools-0.1.19/samtools sort /fastdata/md1jrbx/SHOBHA/BAMS/Pool.bam /fastdata/md1jrbx/SHOBHA/BAMS/Pool.sorted.bam\n";

print OFH "java -Xmx2g -jar /home/md1jrbx/Software/picard-tools-1.114/MarkDuplicates.jar I=/fastdata/md1jrbx/SHOBHA/BAMS/Pool.sorted.bam.bam O=/fastdata/md1jrbx/SHOBHA/BAMS/Pool.sorted.dups.bam M=/fastdata/md1jrbx/SHOBHA/METRICS/Pool.dups.metrics\n";

print OFH "/home/md1jrbx/Software/samtools-0.1.19/samtools rmdup /fastdata/md1jrbx/SHOBHA/BAMS/Pool.sorted.dups.bam /fastdata/md1jrbx/SHOBHA/BAMS/Pool.sorted.nodups.bam\n";

print OFH "/home/md1jrbx/Software/samtools-0.1.19/samtools view -b -q 37 /fastdata/md1jrbx/SHOBHA/BAMS/Pool.sorted.nodups.bam > /fastdata/md1jrbx/SHOBHA/BAMS/Pool.sorted.final.bam\n";

print OFH "/home/md1jrbx/Software/samtools-0.1.19/samtools view -F 0x40 /fastdata/md1jrbx/SHOBHA/BAMS/Pool.sorted.final.bam | cut -f1 | sort | uniq | wc -l > /fastdata/md1jrbx/SHOBHA/METRICS/Pool.adjusted_counts\n";

print OFH "module load apps/R\n";

print OFH "java -Xmx2g -jar /home/md1jrbx/Software/picard-tools-1.114/CollectInsertSizeMetrics.jar I=/fastdata/md1jrbx/SHOBHA/BAMS/Pool.sorted.final.bam O=/fastdata/md1jrbx/SHOBHA/METRICS/Pool.inserts H=/fastdata/md1jrbx/SHOBHA/METRICS/Pool.hist\n";

print OFH "/home/md1jrbx/Software/samtools-0.1.19/samtools flagstat /fastdata/md1jrbx/SHOBHA/BAMS/Pool.sorted.final.bam > /fastdata/md1jrbx/SHOBHA/METRICS/Pool.counts\n";

print OFH "java -Xmx2g -jar /home/md1jrbx/Software/picard-tools-1.114/CollectWgsMetrics.jar I=/fastdata/md1jrbx/SHOBHA/BAMS/Pool.sorted.final.bam O=/fastdata/md1jrbx/SHOBHA/METRICS/Pool.cov R=/fastdata/md1jrbx/HUMAN_GENOME/Homo_sapiens.GRCh38.dna.chromosome_index.fa\n";

print OFH "wc -l /fastdata/md1jrbx/SHOBHA/Pool/R1.fq > /fastdata/md1jrbx/SHOBHA/METRICS/Pool.all_counts\n";
 
close OFH;

system "qsub pipeline_pool.sh";

