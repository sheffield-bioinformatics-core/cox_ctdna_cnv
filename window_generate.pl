#/usr/bin/perl

use strict;

open(FH, "<Sample_Pairs.txt");

while (<FH>)

   {

   chomp;
   (my $sample1, my $sample2, my $name) = split(/\t/, $_, 3);

   open (OFH, ">window_$name.sh");

   print OFH "#!/bin/bash\n\n";

   print OFH "perl /home/md1jrbx/Shobha/bam2windows.pl --samtools-path /home/md1jrbx/Software/samtools-0.1.19/samtools -ts -cs -d /fastdata/md1jrbx/TMP -r 1000 -gc /home/md1jrbx/Shobha/gc1000base_38.txt /fastdata/md1jrbx/SHOBHA/BAMS/$sample1.sorted.final.bam /fastdata/md1jrbx/SHOBHA/BAMS/$sample2.sorted.final.bam > /fastdata/md1jrbx/SHOBHA/WINDOWS/$name.tab\n";

   print OFH "perl /home/md1jrbx/Shobha/clean_tab.pl $name\n";

   close OFH;

   system "qsub window_$name.sh";

   }

close FH;
