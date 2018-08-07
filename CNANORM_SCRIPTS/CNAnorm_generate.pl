#/usr/bin/perl

use strict;

open(FH, "<../Samples.txt");


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

}unless(-e "$rootdir/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY" or mkdir "$rootdir/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY") {
    die "Unable to create $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY\n";


while (<FH>)

   {

   chomp;

   my $sample = $_;

   system ("RScript $scriptdir/CNANORM_SCRIPTS/CNANorm_closest.R $rootdir/WINDOWS/$sample.tab $rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST/$sample_peaks.pdf $rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST/$sample_DNAcopy.pdf $rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST/$sample_smooth.pdf $rootdir/CNANORM/ALL_WINDOWS_1000_CLOSEST/$sample_win.tab");

   system ("RScript $scriptdir/CNANORM_SCRIPTS/CNANorm_closest.R $rootdir/WINDOWS/$sample.clean.tab $rootdir/CNANORM/CLEANED_WINDOWS_1000_CLOSEST/$sample_peaks.pdf $rootdir/CNANORM/CLEANED_WINDOWS_1000_CLOSEST/$sample_DNAcopy.pdf $rootdir/CNANORM/CLEANED_WINDOWS_1000_CLOSEST/$sample_smooth.pdf $rootdir/CNANORM/CLEANED_WINDOWS_1000_CLOSEST/$sample_win.tab");

   system ("RScript $scriptdir/CNANORM_SCRIPTS/CNANorm_closest.R $rootdir/FIXED_WINDOWS/$sample.tab $rootdir/CNANORM/ALL_WINDOWS_FIXED_CLOSEST/$sample_peaks.pdf $rootdir/CNANORM/ALL_WINDOWS_FIXED_CLOSEST/$sample_DNAcopy.pdf $rootdir/CNANORM/ALL_WINDOWS_FIXED_CLOSEST/$sample_smooth.pdf $rootdir/CNANORM/ALL_WINDOWS_FIXED_CLOSEST/$sample_win.tab");                            

   system ("RScript $scriptdir/CNANORM_SCRIPTS/CNANorm_closest.R $rootdir/FIXED_WINDOWS/$sample.clean.tab $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST/$sample_peaks.pdf $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST/$sample_DNAcopy.pdf $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST/$sample_smooth.pdf $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_CLOSEST/$sample_win.tab");

   system ("RScript $scriptdir/CNANORM_SCRIPTS/CNANorm_density.R $rootdir/WINDOWS/$sample.tab $rootdir/CNANORM/ALL_WINDOWS_1000_DENSITY/$sample_peaks.pdf $rootdir/CNANORM/ALL_WINDOWS_1000_DENSITY/$sample_smooth.pdf $rootdir/CNANORM/ALL_WINDOWS_1000_DENSITY/$sample_win.tab");

   system ("RScript $scriptdir/CNANORM_SCRIPTS/CNANorm_density.R $rootdir/WINDOWS/$sample.clean.tab $rootdir/CNANORM/CLEANED_WINDOWS_1000_DENSITY/$sample_peaks.pdf $rootdir/CNANORM/CLEANED_WINDOWS_1000_DENSITY/$sample_smooth.pdf $rootdir/CNANORM/CLEANED_WINDOWS_1000_DENSITY/$sample_win.tab");

   system ("RScript $scriptdir/CNANORM_SCRIPTS/CNANorm_density.R $rootdir/FIXED_WINDOWS/$sample.tab $rootdir/CNANORM/ALL_WINDOWS_FIXED_DENSITY/$sample_peaks.pdf $rootdir/CNANORM/ALL_WINDOWS_FIXED_DENSITY/$sample_smooth.pdf $rootdir/CNANORM/ALL_WINDOWS_FIXED_DENSITY/$sample_win.tab");

   system ("RScript $scriptdir/CNANORM_SCRIPTS/CNANorm_density.R $rootdir/FIXED_WINDOWS/$sample.clean.tab $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY/$sample_peaks.pdf $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY/$sample_smooth.pdf $rootdir/CNANORM/CLEANED_WINDOWS_FIXED_DENSITY/$sample_win.tab");

   }

close FH;

