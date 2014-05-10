#!/usr/bin/perl

use strict;
use Data::Dumper;
open FILE, "<boardlog" or die $!;
use List::Util qw( sum min max);

my $commit;
my %votes;
my $myth = 0;
my @reject;
my %counts;
my $total;
while (<FILE>) {
    chomp;
    my $line = $_;
    if ($line =~ /^commit\s+(.*?)$/) {
        $commit =  $1;
        $myth = 0;
        $votes{'Accept'} = 0;
        $votes{'Reject'} = 0;
    }
    if ($line =~ /Finalized/ && $myth && $votes{'Accept'} > 0 ) {
        push @reject, $votes{'Reject'};
        $counts{$votes{'Reject'}}++;
        $total++;
    }
    elsif ($line =~ /Finalized/) {
#        print "Check $commit $myth $votes{'Accept'}\n";
    }
    elsif ($line =~ /Vote\s+-\s+(Accept|Reject)\s+-/) {
        my ($vote) = $line =~ /Vote\s+-\s+(Accept|Reject)\s+-/;
        $votes{$vote}++;
        if ($line =~ /Julia Lenzi/ || $line =~ /Tim Buckingham/) {
            $myth = 1;
        }
    }
    elsif ($line =~ /Julia Lenzi/ || $line =~ /Tim Buckingham/) {
            $myth = 1;
    }
}

print "Avg: " . sum(@reject)/@reject . "\n";
print "Max: " . max(@reject) . "\n";
print "Min: " . min(@reject) . "\n";
foreach my $count (sort keys %counts) {
    print "$count\t$counts{$count}\n";
}
print "Total: $total\n";
