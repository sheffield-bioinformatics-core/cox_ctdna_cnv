#/usr/bin/perl

use strict;

my $rootdir = $ARGV[0];
my $scriptdir = $ARGV[1];

unless(-e "$rootdir/CNANORM" or mkdir "$rootdir/CNANORM") {
    die "Unable to create $rootdir/CNANORM\n";
}
unless(-e "$rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST" or mkdir "$rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST") {
    die "Unable to create $rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST\n";
}
unless(-e "$rootdir/CNANORM/ALL_WINDOWS_1000_DENSITY" or mkdir "$rootdir/CNANORM/ALL_WINDOWS_1000_DENSITY") {
    die "Unable to create $rootdir/CNANORM/ALL_WINDOWS_1000_DENSITY\n";
}
unless(-e "$rootdir/CNANORM/ALL_WINDOWS_FIXED_CLOSEST" or mkdir "$rootdir/CNANORM/ALL_WINDOWS_FIXED_CLOSEST") {
    die "Unable to create $rootdir/CNANORM/ALL_WINDOWS_FIXED_CLOSEST\n";
}
unless(-e "$rootdir/CNANORM/ALL_WINDOWS_FIXED_DENSITY" or mkdir "$rootdir/CNANORM/ALL_WINDOWS_FIXED_DENSITY") {
    die "Unable to create $rootdir/CNANORM/ALL_WINDOWS_FIXED_DENSITY\n";
}
unless(-e "$rootdir/CNANORM/CLEANED_WINDOWS_1000_CLOSEST" or mkdir "$rootdir/CNANORM/CLEANED_WINDOWS_1000_CLOSEST") {
    die "Unable to create $rootdir/CNANORM/CLEANED_WINDOWS_1000_CLOSEST\n";
}
unless(-e "$rootdir/CNANORM/CLEANED_WINDOWS_1000_DENSITY" or mkdir "$rootdir/CNANORM/CLEANED_WINDOWS_1000_DENSITY") {
    die "Unable to create $rootdir/CNANORM/CLEANED_WINDOWS_1000_DENSITY\n";
}
unless(-e "$rootdir/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST" or mkdir "$rootdir/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST") {
    die "Unable to create $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST\n";

}
unless(-e "$rootdir/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY" or mkdir "$rootdir/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY") {
    die "Unable to create $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY\n";
}

open(FH, "<Samples.txt");

while (<FH>)

   {

   chomp;

   my $sample = $_;
   print "$sample\n";


   system ("module load apps/R/3.3.2/gcc-4.8.5");

   print "Rscript $scriptdir/CNANORM_SCRIPTS/CNAnorm_closest.R $rootdir/WINDOWS/$sample.tab $rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST/$sample\_peaks.pdf $rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST/$sample\_DNAcopy.pdf $rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST/$sample\_smooth.pdf $rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST/$sample\_win.tab\n";
   system ("Rscript $scriptdir/CNANORM_SCRIPTS/CNAnorm_closest.R $rootdir/WINDOWS/$sample.tab $rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST/$sample\_peaks.pdf $rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST/$sample\_DNAcopy.pdf $rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST/$sample\_smooth.pdf $rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST/$sample\_win.tab");

   system ("Rscript $scriptdir/CNANORM_SCRIPTS/CNAnorm_closest.R $rootdir/WINDOWS/$sample.clean.tab $rootdir/CNANORM/CLEANED_WINDOWS_1000_CLOSEST/$sample\_peaks.pdf $rootdir/CNANORM/CLEANED_WINDOWS_1000_CLOSEST/$sample\_DNAcopy.pdf $rootdir/CNANORM/CLEANED_WINDOWS_1000_CLOSEST/$sample\_smooth.pdf $rootdir/CNANORM/CLEANED_WINDOWS_1000_CLOSEST/$sample\_win.tab");

   system ("Rscript $scriptdir/CNANORM_SCRIPTS/CNAnorm_closest.R $rootdir/FIXED_WINDOWS/$sample.tab $rootdir/CNANORM/ALL_WINDOWS_FIXED_CLOSEST/$sample\_peaks.pdf $rootdir/CNANORM/ALL_WINDOWS_FIXED_CLOSEST/$sample\_DNAcopy.pdf $rootdir/CNANORM/ALL_WINDOWS_FIXED_CLOSEST/$sample\_smooth.pdf $rootdir/CNANORM/ALL_WINDOWS_FIXED_CLOSEST/$sample\_win.tab");                            

   system ("Rscript $scriptdir/CNANORM_SCRIPTS/CNAnorm_closest.R $rootdir/FIXED_WINDOWS/$sample.clean.tab $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST/$sample\_peaks.pdf $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST/$sample\_DNAcopy.pdf $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST/$sample\_smooth.pdf $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST/$sample\_win.tab");

   system ("Rscript $scriptdir/CNANORM_SCRIPTS/CNAnorm_density.R $rootdir/WINDOWS/$sample.tab $rootdir/CNANORM/ALL_WINDOWS_1000_DENSITY/$sample\_peaks.pdf $rootdir/CNANORM/ALL_WINDOWS_1000_DENSITY/$sample\_smooth.pdf $rootdir/CNANORM/ALL_WINDOWS_1000_DENSITY/$sample\_win.tab");

   system ("Rscript $scriptdir/CNANORM_SCRIPTS/CNAnorm_density.R $rootdir/WINDOWS/$sample.clean.tab $rootdir/CNANORM/CLEANED_WINDOWS_1000_DENSITY/$sample\_peaks.pdf $rootdir/CNANORM/CLEANED_WINDOWS_1000_DENSITY/$sample\_smooth.pdf $rootdir/CNANORM/CLEANED_WINDOWS_1000_DENSITY/$sample\_win.tab");

   system ("Rscript $scriptdir/CNANORM_SCRIPTS/CNAnorm_density.R $rootdir/FIXED_WINDOWS/$sample.tab $rootdir/CNANORM/ALL_WINDOWS_FIXED_DENSITY/$sample\_peaks.pdf $rootdir/CNANORM/ALL_WINDOWS_FIXED_DENSITY/$sample\_smooth.pdf $rootdir/CNANORM/ALL_WINDOWS_FIXED_DENSITY/$sample\_win.tab");

   system ("Rscript $scriptdir/CNANORM_SCRIPTS/CNAnorm_density.R $rootdir/FIXED_WINDOWS/$sample.clean.tab $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY/$sample\_peaks.pdf $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY/$sample\_smooth.pdf $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY/$sample\_win.tab");

   }

close FH;

