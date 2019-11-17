#!/usr/bin/perl
use 5.10.0;
use strict;
use warnings;

use Time::Piece;

# dm -- "daemonize" a process

# dm runs a process in the background, redirecting the combined STDOUT and
# STDERR to a file in ~/tmp/dm.

# Usage
#   dm cmd [args]   # run cmd + args in background
#   dm              # examine output directory
#   dm -c           # delete *.done files that already existed, then examine output directory

# For more details see https://github.com/sitaramc/notes/blob/master/dm.mkd

my $base = "$ENV{HOME}/tmp/dm";
-d $base or system("mkdir -p $base");

my $clean = shift if @ARGV == 1 and $ARGV[0] eq '-c';

unless (@ARGV) {
    chdir($base);
    unlink glob "*.done" if $clean;
    for my $pid (glob("*")) {
        rename $pid, "$pid.done" if $pid =~ /^\d+$/ and not -d "/proc/$pid";
    }
    exec("sh", "-c", $ENV{BQ_FILEMANAGER}||"vifm" . " $base");
    # note that $ENV{BQ_FILEMANAGER} can be command+options
}

unless ($0 eq $ARGV[0]) {
    # $0 = "dm", @ARGV = "sleep 5" -> ( (  "dm dm sleep 5" ) & )
    fork() or fork() or exec($0, $0, @ARGV);
    exit;
}

# $0 = "dm", @ARGV = "dm sleep 5" -> exec "sleep 5"
shift;

open(STDOUT, ">", "$base/$$");
say localtime()->strftime("%F %T");
say join(" ", "+", @ARGV) . "\n";
open(STDERR, ">&STDOUT");
open(STDIN, "<", "/dev/null");

exec(@ARGV);
