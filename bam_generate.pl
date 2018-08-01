#/usr/bin/perl

use strict;

open(FH, "<Samples.txt");

my ($rootdir) = @ARGV;

my $genome_bwa = "/shared/bioinformatics_core1/Shared/cox/cnv/GENOME/Homo_sapiens.GRCh38.dna.chromosome_index";
my $genome_fa = "/shared/bioinformatics_core1/Shared/cox/cnv/GENOME/Homo_sapiens.GRCh38.dna.chromosome_index.fa.gz";

my $picard = "/home/md1mpar/wc/picard-2.18.10/picard.jar";

while (<FH>){

    chomp;
    my $sample = $_;

    open (OFH, ">pipeline_$sample.sh");

    print OFH "#!/bin/bash\n\n";

    print OFH "#\$ -S /bin/bash\n";
    print OFH "#\$ -l rmem=40G\n";
    print OFH "#\$ -m bea\n";
    print OFH "#\$ -M matthew.parker\@sheffield.ac.uk\n";
    print OFH "#\$ -l h_rt=4:00:00\n";
    print OFH "#\$ -o $sample\_bam_generate.out\n";
    print OFH "#\$ -e $sample\_bam_generate.err\n";
    print OFH "#\$ -N $sample\n";
    print OFH "#\$ -pe openmp 6\n\n";

    print OFH "module load apps/bwa/0.7.17/gcc-6.2\n";

    print OFH "module load apps/SAMtools/1.7/gcc-4.9.4\n";

    print OFH "module load apps/java/jdk1.8.0_102/binary\n\n";

    print OFH "bwa mem -M -t 6 $genome_bwa $rootdir/$sample/*R1*.fastq.gz $rootdir/$sample/*R2*.fastq.gz | samtools sort - | samtools view -bh - > $rootdir/BAMS/$sample.sorted.bam\n";

    print OFH "java -Xmx2g -jar $picard MarkDuplicates I=$rootdir/BAMS/$sample.sorted.bam O=$rootdir/BAMS/$sample.sorted.dups.bam M=$rootdir/METRICS/$sample.dups.metrics\n";

    print OFH "samtools rmdup $rootdir/BAMS/$sample.sorted.dups.bam $rootdir/BAMS/$sample.sorted.nodups.bam\n";

    print OFH "samtools view -b -q 37 $rootdir/BAMS/$sample.sorted.nodups.bam > $rootdir/BAMS/$sample.sorted.final.bam\n";

    print OFH "samtools view -F 0x40 $rootdir/BAMS/$sample.sorted.final.bam | cut -f1 | sort | uniq | wc -l > $rootdir/METRICS/$sample.adjusted_counts\n";

    print OFH "module load apps/R\n";

    print OFH "java -Xmx2g -jar $picard CollectInsertSizeMetrics I=$rootdir/BAMS/$sample.sorted.final.bam O=$rootdir/METRICS/$sample.inserts H=/$rootdir/METRICS/$sample.hist\n";

    print OFH "samtools flagstat $rootdir/BAMS/$sample.sorted.final.bam > $rootdir/METRICS/$sample.counts\n";

    print OFH "java -Xmx2g -jar $picard CollectWgsMetrics I=$rootdir/BAMS/$sample.sorted.final.bam O=$rootdir/METRICS/$sample.cov R=$genome_fa\n";

    print OFH "wc -l $rootdir/$sample/*R1*.fastq.gz > $rootdir/METRICS/$sample.all_counts\n";

    close OFH;

    #system "qsub -q bioinf-core.q -P bioinf-core pipeline_$sample.sh";

   }

close FH;
