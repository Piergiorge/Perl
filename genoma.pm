#!/usr/bin/perl
package genoma;
use strict;
use warnings;

sub parser_gen{
        my %uniprot;
        my @id_seq = @_;
        foreach my $line (@id_seq){
                if ($line =~ /^>.*$/){   
                        my @sp = split (/=/, $line);
                        if ($sp[1] =~ s/\sGN//){
                                #print "$sp[1]\n";
                                my @prot = split (/\|/, $line);
                                #print "$prot[1]\n";
                                $uniprot{$sp[1]}{$prot[1]}=1;
                        }
                }
        }
        foreach my $genoma(keys %uniprot){
                print "*****************************************\n";
                print "$genoma\n\n";
                foreach my $prot_id (keys %{$uniprot{$genoma}}){
                        print "\tUniprot_ID:$prot_id\n";
                }
                print "\n";
        }
        return %uniprot;
}
1;
