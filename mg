#!/usr/bin/perl -s
use strict;
use warnings;
use 5.10.0;
use Data::Dumper;

# TODO: markdown header with -mh (i.e., each patt to be prefixed with "^#.*").
# A naive implementation may require "/m" flag, maybe other complications

sub usage {
    print STDERR q(
mg -- multi-grep

Usage:
    mg [options] patt1 [patt2] [-patt3] ...

`mg` allows (a) multiple patterns, including negatives, a la `fzf` (except we
allow "-" or "!" as the negation prefix), (b) filtering based on paragraphs
instead of lines, and (c) taking filenames from STDIN.

    -x  STDIN is a list of filenames, not data.  This is the only way you can
        supply a list of filenames, because arguments are ALWAYS search terms.
    -p  search and report by para instead of by line.  (Paragraphs are
        separated by one or more blank lines).
    -l  like grep's -l, but remember filenames only come from STDIN!

);
    exit 1;
}

our($x, $p, $l, $h);

usage unless @ARGV;
usage if $h;

my $exitcode = 1;

# convert fzf-style negatives to our style
map { s/^!/-/ } @ARGV;
# separate positive and negative search terms
my @yes = _keys(1, @ARGV);
my @no = _keys(0, @ARGV);
say STDERR Dumper \@yes, \@no if $ENV{D};
@ARGV = ();

# $x means input and output is a list of filenames, not actual data
my @files = qw(-);
@files = <> if $x;
chomp(@files);

# search and report by para
$/ = "" if $p;

for my $f (@files) {
    _grep($f);
}

exit $exitcode;

# ----------------------------------------------------------------------

sub _grep {
    my $f = shift;
    my $f_is_printed = 0;

    if ($f eq '-') {
        open(F, "<-") or die "'$f': $!";
    } else {
        open(F, "<", $f) or die "'$f': $!";
    }

    while(<F>) {

        # if ( _mg($p ? "$f $_" : $_) ) {
        # do we need this?  What are the chances that a search term appears in
        # the *filename* but not within the file itself (and we would want
        # that to be "found")?

        if ( _mg($_) ) {
            $exitcode = 0;
            if ($l) {
                print "$f\n";
                last;
            } else {
                print "==> $f <==\n\n" if $x and not $f_is_printed++;
                print $_;
            }
        }
    }
    close F;
}

sub _keys {
    if ( +shift() ) {
        _smartcase( grep { ! /^-/ } @_ );
    } else {
        _smartcase( map { s/^-//; $_ } grep { /^-/ } @_ );
    }
}
sub _smartcase {
    for my $k (@_) {
        $k = "(?i)$k" unless $k =~ /[A-Z]/;
    }
    @_;
}

sub _mg {
    my $t = shift;

    for my $k (@yes) {
        return 0 unless $t =~ /$k/;
    }
    for my $k (@no) {
        return 0 if $t =~ /$k/;
    }

    return 1;
}
