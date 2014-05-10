#!/usr/bin/perl
use strict;

use JSON;
use Data::Dumper;

my $MF = $ARGV[0];
my $LF = $ARGV[1];
my $AF = $ARGV[2];

my %modules;
my %lectures;
my %assignments;
my $modulename = 'module';

my @syllabus = ();

open FILE, "<$MF" or die "Can't open $MF $!\n";
while (<FILE>) {
    chomp;
    next unless /^\d/;
    my @cols = split /\t/;
    $modules{$cols[0]} = {
        'id' => $modulename . $cols[0],
        'label' => "$cols[1] $cols[2]", 
        'status' => 'published',
        'lectures' => [],
        'assignments' => []
    };
}
close FILE;
open FILE, "<$LF" or die "Can't open $LF $!\n";
while (<FILE>) {
    chomp;
    next unless /^\d/;
    my @cols = split /\t/;
    $lectures{$cols[0]} = {'label' => "$cols[1]", 'description' => "$cols[2]"};
}
close FILE;
open FILE, "<$AF" or die "Can't open $AF $!\n";
while (<FILE>) {
    chomp;
    next unless /^\d/;
    my @cols = split /\t/;
    my $module = $cols[0];
    my $label = $cols[1];
    my $index = $cols[2];
    next unless scalar @cols == 9;
    my @uris = split /,/, $cols[3];
    my @labels = split /,/, $cols[4];
    my @urns = split /,/, $cols[5]; 
    my $ctype = $cols[6];
    my $level = $cols[7];
    my $group = $cols[8];
    # add the notional work uris to the annotation targets
    my @work_uris = map { my $uri = $_; $uri =~ s/\.perseus-eng1//; $uri; } 
                    @uris;
    map { push @uris, $_ } @work_uris;
    my @display_items = map { {'uri' => $_, 'ctype' => $ctype } } @urns;
    my %assign = (
        'label' => $label,
        'annotation_targets' => \@uris,
        'display_items' => \@display_items,
        'level' => $level,
        'group' => $group
    );
    $modules{$module}{assignments}[$index-1] = \%assign;
}

foreach my $module (sort { $a <=> $b } keys %modules) {
    push @syllabus, $modules{$module};
}

my %Perseids = ( 'syllabus' => \@syllabus );

print "Perseids = \n";
print to_json(\%Perseids, {pretty =>1});
print ";\n";


