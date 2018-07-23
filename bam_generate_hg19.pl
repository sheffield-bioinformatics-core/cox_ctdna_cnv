#/usr/bin/perl

use strict;

open(FH, "<Samples.txt");

while (<FH>)

   {

   chomp;
   my $sample = $_;

   open (OFH, ">pipeline_$sample.hg19.sh");

   print OFH "#!/bin/bash\n\n#\$ -pe openmp 6\n\n";

   print OFH "/home/md1jrbx/Software/bwa-0.7.10/bwa mem -M -t 6 /fastdata/md1jrbx/HG19/Homo_sapiens.GRCh37.75.dna.chromosome.fa /fastdata/md1jrbx/SHOBHA/$sample/R1.fq /fastdata/md1jrbx/SHOBHA/$sample/R2.fq > /fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.sam\n";

   print OFH "/home/md1jrbx/Software/samtools-0.1.19/samtools view -Sb /fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.sam > /fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.bam\n";

   print OFH "/home/md1jrbx/Software/samtools-0.1.19/samtools sort /fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.bam /fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.sorted.bam\n";

   print OFH "java -Xmx2g -jar /home/md1jrbx/Software/picard-tools-1.114/MarkDuplicates.jar I=/fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.sorted.bam.bam O=/fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.sorted.dups.bam M=/fastdata/md1jrbx/SHOBHA/HG19_METRICS/$sample.dups.metrics\n";

   print OFH "/home/md1jrbx/Software/samtools-0.1.19/samtools rmdup /fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.sorted.dups.bam /fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.sorted.nodups.bam\n";

   print OFH "/home/md1jrbx/Software/samtools-0.1.19/samtools view -b -q 37 /fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.sorted.nodups.bam > /fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.sorted.final.bam\n";

   print OFH "/home/md1jrbx/Software/samtools-0.1.19/samtools view -F 0x40 /fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.sorted.final.bam | cut -f1 | sort | uniq | wc -l > /fastdata/md1jrbx/SHOBHA/HG19_METRICS/$sample.adjusted_counts\n";

   print OFH "module load apps/R\n";

   print OFH "java -Xmx2g -jar /home/md1jrbx/Software/picard-tools-1.114/CollectInsertSizeMetrics.jar I=/fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.sorted.final.bam O=/fastdata/md1jrbx/SHOBHA/HG19_METRICS/$sample.inserts H=/fastdata/md1jrbx/SHOBHA/HG19_METRICS/$sample.hist\n";

   print OFH "/home/md1jrbx/Software/samtools-0.1.19/samtools flagstat /fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.sorted.final.bam > /fastdata/md1jrbx/SHOBHA/HG19_METRICS/$sample.counts\n";

   print OFH "java -Xmx2g -jar /home/md1jrbx/Software/picard-tools-1.114/CollectWgsMetrics.jar I=/fastdata/md1jrbx/SHOBHA/HG19_BAMS/$sample.sorted.final.bam O=/fastdata/md1jrbx/SHOBHA/HG19_METRICS/$sample.cov R=/fastdata/md1jrbx/HG19/Homo_sapiens.GRCh37.75.dna.chromosome.fa\n";

   print OFH "wc -l /fastdata/md1jrbx/SHOBHA/$sample/R1.fq > /fastdata/md1jrbx/SHOBHA/HG19_METRICS/$sample.all_counts\n";
 
   close OFH;

   system "qsub pipeline_$sample.hg19.sh";

   }

close FH;
