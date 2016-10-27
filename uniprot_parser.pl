#!/usr/bin/perl

use strict;
use warnings;
use genoma;

my $seqs = "$ARGV[0];
my @id_seq;

open (IN, '<', $seqs);

foreach my $line (<IN>){
        chomp $line;
        push (@id_seq, $line);
	#print "@id_seq\n";
}
close (IN);

&genoma::parser_gen(@id_seq);

exit;
