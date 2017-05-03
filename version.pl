#!/usr/bin/env perl

$f = $ARGV[0];
$f =~ /(\d+\-\d+.\d+)/;
$f = $1;
$f =~ s/\-/\./;

print "$f\n";
