#/usr/bin/perl

use strict;
use File::Basename;

my $file = $ARGV[0];
my $outfile = $ARGV[1];
my $dir = dirname($outfile);
my $clean_outfile_tmp = basename($outfile,".bed");
my $clean_outfile = "$dir/$clean_outfile_tmp";
print "$clean_outfile";
my $coord1 = 0;
my $coord2 = 0;
my $line_num = 0;

my $bedtools = "/home/md1mpar/wc/bedtools2-2.20.1/bin/bedtools"; #bedtools2-2.20.1
my $excluded_regions = "/home/md1mpar/wc/cox_ctdna_cnv/Excluded_Regions.bed"; #/home/md1jrbx/Shobha/Excluded_Regions.bed

open(FH, "<$file");

LOOP: while (<FH>)

   {

   chomp;
   my @columns = split(/\t/, $_);

   $coord1 = $columns[1] if $line_num == 1; 
   $coord2 = $columns[1] if $line_num == 2;

   last LOOP if $line_num == 3;

   $line_num++;

   } 

close FH;

my $diff = $coord2 - $coord1;

my $line_num = 0;

open(FH, "<$file");
open(OFH, ">$outfile");

while (<FH>)

   {

   chomp;
   my @columns = split(/\t/, $_);

   my $end = $columns[1] + $diff - 1;

   print OFH "$columns[0]\t$columns[1]\t$end\t$columns[2]|$columns[3]|$columns[4]\n" if ($line_num > 0);

   $line_num++;

   } 

close OFH;
close FH;

system ("$bedtools intersect -a $outfile -b $excluded_regions -v > $clean_outfile.clean.bed");

my $line_num = 0;

print "$clean_outfile";

open(FH, "<$clean_outfile.clean.bed");
open(OFH, ">$clean_outfile.clean.tab");

while (<FH>)

   {

   chomp;
   my @columns = split(/\t/, $_);
   my @bits = split(/\|/, $columns[3]);

   print OFH "Chr\tPos\tTest\tNorm\tGC\n" if ($line_num == 0);
   print OFH "$columns[0]\t$columns[1]\t$bits[0]\t$bits[1]\t$bits[2]\n" if ($line_num > 0 && $columns[0] ne "X" && $columns[0] ne "Y" && $columns[0] ne "MT");

   $line_num++;

   }

close OFH;
close FH;
