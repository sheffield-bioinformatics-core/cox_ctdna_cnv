#/usr/bin/perl

use strict;

my $file = $ARGV[0];
my $coord1 = 0;
my $coord2 = 0;
my $line_num = 0;

open(FH, "</fastdata/md1jrbx/SHOBHA/FIXED_WINDOWS/$file.tab");

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

open(FH, "</fastdata/md1jrbx/SHOBHA/FIXED_WINDOWS/$file.tab");
open(OFH, ">/fastdata/md1jrbx/SHOBHA/FIXED_WINDOWS/$file.bed");

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

system ("/home/md1jrbx/Software/bedtools2-2.20.1/bin/bedtools intersect -a /fastdata/md1jrbx/SHOBHA/FIXED_WINDOWS/$file.bed -b /home/md1jrbx/Shobha/Excluded_Regions.bed -v > /fastdata/md1jrbx/SHOBHA/FIXED_WINDOWS/$file.clean.bed");

my $line_num = 0;

open(FH, "</fastdata/md1jrbx/SHOBHA/FIXED_WINDOWS/$file.clean.bed");
open(OFH, ">/fastdata/md1jrbx/SHOBHA/FIXED_WINDOWS/$file.clean.tab");

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
