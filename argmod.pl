#!/usr/bin/perl
use warnings;
use strict;
use 5.10.0;

use Data::Dumper;

# Usage: $0 "argument list"
# STDIN: one or more rules of the form: "pattern => replacement"

# Modifies argument list based on the given rules.

# For more details and a couple of examples, see:
#   https://github.com/sitaramc/notes/blob/master/argmod.mkd

# A word about spaces within arguments: the assumption is that you don't have
# spaces in any of the arguments presented as "pattern" and "replacement".
# They may be present in the argument list, and those will be fine, but the
# words in the pattern and replacement are treated as space-separated tokens.

# Also, the output is **one argument per LINE**, since that is the only way to
# pass stuff back to bash if there are spaces in the arguments.  (`argmod`
# will use `readarray -t` to read those lines in).

my $args = join( "\n", @ARGV );
@ARGV=();

sub dbg {
    return unless $ENV{D};
    return say STDERR (+shift) if @_ == 1;

    my @n = split ' ', (+shift);
    for my $n (@n) {
        my $v = join "•", split("\n", (+shift));
        say STDERR "$n:\t" . $v;
    }
}

dbg("$$", $args);
while (<>) {
    next if /^\s*#/;
    next unless /\S/;

    my ($patt, $repl);
    next unless ($patt, $repl) = m(\s*(\S.*?)\s+=>\s+(\S.*));
    # dbg("args", $args);
    # dbg("patt repl", $patt, $repl);

    $patt =~ s/ +/\n/g;
    $repl =~ s/ +/\n/g;
    $repl =~ s/\\n/\n/g; # kludge

    # munge pattern into a proper regex
    $patt =~ s/ +/\\s+/g;
    $patt =~ s/(?<!\\)%%/([\\s\\S]*)/g;
    $patt =~ s/(?<!\\)%/(.+)/g;

    my $old = $args;

    $args =~ s((?<![\h\S])$patt(?![\h\S]))($repl)g;
    # what about /i?  Do we care/cater to that?

    # -- seems to have problems in perl 5.30.0 ??? -- my @c = @{^CAPTURE};
    my @c = ($1,$2,$3,$4,$5,$6,$7,$8,$9);
    unshift @c, 0;    # dummy 0-th element
    $args =~ s((?!\\)%(\d))($c[$1])g;

    dbg("patt repl ==>", $patt, $repl, $args) if $old ne $args;
    dbg("")                                   if $old ne $args;
}

say $args;
