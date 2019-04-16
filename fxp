#!/usr/bin/perl
use warnings;
use strict;
use 5.10.0;

# fxp -- file transfer with progress

# ok, it's just massaging the output of `rsync -avP`, really, just to get a
# non-scrolling progress output!

$|++;
my $el   = `tput el`;   chomp $el;      # clear to end-of-line
my $cuu1 = `tput cuu1`; chomp $cuu1;    # cursor up one line
my $cols = `tput cols`; chomp $cols;    # number of columns in this screen

open( RSYNC, "-|", "rsync", "-avP", @ARGV );

my $buf = '';
my ( $rc, $fn, $xfr, $prog, $stats ) = ('') x 5;

print "\n\n";

# no amount of cajoling will make perl accept both \r AND \n as "$/", so I had to resort to sysread!
while ( $rc = sysread( RSYNC, $buf, 1, length($buf) ) ) {
    next unless $buf =~ s/[\r\n]$//;

    # for troubleshooting; bypasses all the munging and just prints almost-raw
    # (i.e., raw except for \r -> \n)
    if ( $ENV{D} ) {
        print "$buf\n";
        $buf = '';
        next;
    }

    if ( $buf =~ /\((xfr#.*)\)/ ) {
        $xfr = $1;
        print "$el$xfr\t$prog\r";
    } elsif ( $buf =~ /\d+%/ ) {
        $prog = $buf;
        print "$el$xfr\t$prog\r";
    } elsif ( $buf =~ /^(sent|total) / ) {
        print "\n$buf";
    } elsif ( $buf =~ /\S/ ) {
        # it's a filename!
        substr( $buf, 0, length($buf) - $cols + 4, "..." ) if length($buf) >= $cols;
        print "$cuu1$buf$el\n";
    }
    # empty lines ignored

    $buf = '';
}

print "\n";
