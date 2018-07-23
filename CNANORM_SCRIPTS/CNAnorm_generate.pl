#/usr/bin/perl

use strict;

open(FH, "<../Sample_Pairs.txt");

while (<FH>)

   {

   chomp;
   my @columns = split(/\t/, $_);

   system ("RScript CNANorm_closest.R /Users/james/Documents/PROJECTS/Shobha/Pool/WINDOWS/$columns[2].tab /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/ALL_WINDOWS_1000_CLOSEST/$columns[2]_peaks.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/ALL_WINDOWS_1000_CLOSEST/$columns[2]_DNAcopy.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/ALL_WINDOWS_1000_CLOSEST/$columns[2]_smooth.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/ALL_WINDOWS_1000_CLOSEST/$columns[2]_win.tab"); 

   system ("RScript CNANorm_closest.R /Users/james/Documents/PROJECTS/Shobha/Pool/WINDOWS/$columns[2].clean.tab /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/CLEANED_WINDOWS_1000_CLOSEST/$columns[2]_peaks.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/CLEANED_WINDOWS_1000_CLOSEST/$columns[2]_DNAcopy.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/CLEANED_WINDOWS_1000_CLOSEST/$columns[2]_smooth.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/CLEANED_WINDOWS_1000_CLOSEST/$columns[2]_win.tab");

   system ("RScript CNANorm_closest.R /Users/james/Documents/PROJECTS/Shobha/Pool/FIXED_WINDOWS/$columns[2].tab /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/ALL_WINDOWS_FIXED_CLOSEST/$columns[2]_peaks.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/ALL_WINDOWS_FIXED_CLOSEST/$columns[2]_DNAcopy.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/ALL_WINDOWS_FIXED_CLOSEST/$columns[2]_smooth.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/ALL_WINDOWS_FIXED_CLOSEST/$columns[2]_win.tab");                            

   system ("RScript CNANorm_closest.R /Users/james/Documents/PROJECTS/Shobha/Pool/FIXED_WINDOWS/$columns[2].clean.tab /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST/$columns[2]_peaks.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST/$columns[2]_DNAcopy.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST/$columns[2]_smooth.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST/$columns[2]_win.tab");

   system ("RScript CNANorm_density.R /Users/james/Documents/PROJECTS/Shobha/Pool/WINDOWS/$columns[2].tab /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/ALL_WINDOWS_1000_DENSITY/$columns[2]_peaks.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/ALL_WINDOWS_1000_DENSITY/$columns[2]_smooth.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/ALL_WINDOWS_1000_DENSITY/$columns[2]_win.tab");

   system ("RScript CNANorm_density.R /Users/james/Documents/PROJECTS/Shobha/Pool/WINDOWS/$columns[2].clean.tab /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/CLEANED_WINDOWS_1000_DENSITY/$columns[2]_peaks.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/CLEANED_WINDOWS_1000_DENSITY/$columns[2]_smooth.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/CLEANED_WINDOWS_1000_DENSITY/$columns[2]_win.tab");

   system ("RScript CNANorm_density.R /Users/james/Documents/PROJECTS/Shobha/Pool/FIXED_WINDOWS/$columns[2].tab /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/ALL_WINDOWS_FIXED_DENSITY/$columns[2]_peaks.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/ALL_WINDOWS_FIXED_DENSITY/$columns[2]_smooth.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/ALL_WINDOWS_FIXED_DENSITY/$columns[2]_win.tab");

   system ("RScript CNANorm_density.R /Users/james/Documents/PROJECTS/Shobha/Pool/FIXED_WINDOWS/$columns[2].clean.tab /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY/$columns[2]_peaks.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY/$columns[2]_smooth.pdf /Users/james/Documents/PROJECTS/Shobha/Pool/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY/$columns[2]_win.tab");

   }

close FH;

