#!/usr/bin/perl
use strict;
use Data::Dumper;

my %assignments;
open FILE, "<assignments.csv" or die $!;
while (<FILE>) {
    chomp;
    my @fields = split /\t/;
    my $level = $fields[0];
    my $label = $fields[1];
    $label =~ s/<\/?i>//g;
    $label =~ s/\s+/ /g;
    my $target = $fields[2];
    $assignments{$target} = {'label' => $label, 
                             'level' => $level,
                             'accepted' => 0,
                             'pending' => 0};
}
close FILE;
open FILE, "<accepted" or die $!;
while (<FILE>) {
    chomp;
    if (exists $assignments{$_}) {
        $assignments{$_}{'accepted'}++;
    }
}
close FILE;
open FILE, "<pending" or die $!;
while (<FILE>) {
    chomp;
    if (exists $assignments{$_}) {
        $assignments{$_}{'pending'}++;
    }
}
close FILE;

print join "\t", qw(Assignment URI Level Potential Accepted Pending);
print "\n";
foreach my $target (keys %assignments) {
    my $pot = $assignments{$target}{'accepted'} + $assignments{$target}{'pending'};
    print join "\t", ($assignments{$target}{label},$target,$assignments{$target}{'level'},$pot,$assignments{$target}{'accepted'},$assignments{$target}{'pending'});
    print "\n";
}
