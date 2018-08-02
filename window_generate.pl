#/usr/bin/perl

use strict;

my ($rootdir,$scriptdir) = @ARGV;

my $gcbases = "/home/md1mpar/wc/cox_ctdna_cnv/gc1000base_38.txt";
my $poolbam = "/shared/bioinformatics_core1/Shared/cox/cnv/POOLED_NORMAL/Pool.sorted.final.bam";

open(FH, "<Samples.txt");

while (<FH>){

    chomp;
    my $sample = $_;

    open (OFH, ">window_$sample.sh");

    print OFH "#!/bin/bash\n\n";

    print OFH "#\$ -S /bin/bash\n";
    print OFH "#\$ -l rmem=20G\n";
    print OFH "#\$ -m bea\n";
    print OFH "#\$ -M matthew.parker\@sheffield.ac.uk\n";
    print OFH "#\$ -l h_rt=4:00:00\n";
    print OFH "#\$ -o $sample\_window_generate.out\n";
    print OFH "#\$ -e $sample\_window_generate.err\n";
    print OFH "#\$ -N $sample\n";
    print OFH "#\$ -pe openmp 1\n\n";

    print OFH "module load apps/SAMtools/1.7/gcc-4.9.4\n";

    print OFH "samtools = `which samtools`";


    print OFH "perl $scriptdir/bam2windows.pl --samtools-path \${samtools} -ts -cs -d $rootdir/TMP -r 1000 -gc $gcbases $rootdir/BAMS/$sample.sorted.final.bam $poolbam > $rootdir/BAMS/WINDOWS/$sample.tab\n";

    print OFH "perl $scriptdir/clean_tab.pl $sample\n";

    close OFH;

#    system "qsub -q bioinf-core.q -P bioinf-core window_$name.sh";
}

close FH;
