#/usr/bin/perl

use strict;

my %metrics = ();

open(FH, "<Pool_Sample.txt");

while (<FH>)

   {

   chomp;
   my $sample = $_;

   open(CFH, "</fastdata/md1jrbx/SHOBHA/METRICS/$sample.adjusted_counts");

   LOOP: while (<CFH>)

      {

      chomp;
      my @columns = split(/\s+/, $_);

      $metrics{$sample}[0] = $columns[0];

      last LOOP;

      }

   close CFH;

   }

close FH;

my $i = 0;

open(FH, "<Pool_Sample.txt");

while (<FH>)

   {

   chomp;
   my $sample = $_;

   open(CFH, "</fastdata/md1jrbx/SHOBHA/METRICS/$sample.cov");

   LOOP: while (<CFH>)

      {

      if ($i == 7)

         {

         chomp;
         my @columns = split(/\s+/, $_);
         
         $metrics{$sample}[1] = $columns[1];

         $i = 0;

         last LOOP;

         }

      $i++;

      }

   close CFH;

   }

close FH;

my $i = 0;

open(FH, "<Pool_Sample.txt");

while (<FH>)

   {

   chomp;
   my $sample = $_;

   open(CFH, "</fastdata/md1jrbx/SHOBHA/METRICS/$sample.dups.metrics");

   LOOP: while (<CFH>)

      {

      if ($i == 7)

         {

         chomp;
         my @columns = split(/\t/, $_);

         $metrics{$sample}[2] = $columns[7];

         $i = 0;

         last LOOP;

         }

      $i++;

      }

   close CFH;

   }

close FH;

my $i = 0;

open(FH, "<Pool_Sample.txt");

while (<FH>)

   {

   chomp;
   my $sample = $_;

   open(CFH, "</fastdata/md1jrbx/SHOBHA/METRICS/$sample.inserts");

   LOOP: while (<CFH>)

      {

      if ($i == 7)

         {

         chomp;
         my @columns = split(/\t/, $_);

         $metrics{$sample}[3] = $columns[4];

         $i = 0;

         last LOOP;

         }

      $i++;

      }

   close CFH;

   }

close FH;


open(FH, "<Pool_Sample.txt");

while (<FH>)

   {

   chomp;
   my $sample = $_;

   open(CFH, "</fastdata/md1jrbx/SHOBHA/METRICS/$sample.all_counts");

   while (<CFH>)

      {

      chomp;
      my @columns = split(/\s/, $_);

      $metrics{$sample}[4] = $columns[0];

      }

   close CFH;

   }

close FH;

open(OFH, ">Metrics.txt");

print OFH "Sample ID\tNo. of Reads\tNo. of Mapped Reads\t% mapped\tNo. of paired reads\tX Coverage\t% Duplication\tFragment Length (bp)\n";

foreach my $s (keys %metrics)

   {

   my $read_counts = $metrics{$s}[4] / 2;
   my $mapped_reads = $metrics{$s}[0] * 2;
   my $pc_mapped = ($mapped_reads / $read_counts) * 100;

   printf OFH "%s\t%d\t%d\t%3.2f\t%d\t%3.2f\t%3.4f\t%3.2f\n", $s, $read_counts, $mapped_reads, $pc_mapped, $metrics{$s}[0], $metrics{$s}[1], $metrics{$s}[2], $metrics{$s}[3];

   }

close OFH;
