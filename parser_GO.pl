#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];

open (IN, "<", $file);
my $size = 0;
my $code = "";

my %hash;

foreach my $line (<IN>){
        chomp $line;
        #print "$line\n";
        my @split = split (/\t/,$line);
        #0,2,7
        #print "$#split\n";
        if ($#split == 7){
                if ($split[0] =~ /GO cellular component complete/){
                        $code = "CC";
                }
                elsif ($split[0] =~ /GO biological process complete/){
                        $code = "BP";
                }
                elsif ($split[0] =~ /GO molecular function complete/){
                        $code = "MF";
                }
                if ($split[2] =~ /upload_1\ \((.*)\)/){
                        #print "$split[0]\t$split[2]\t$split[7]\n";
                        $size = $1;
                }
                else{
                        #print "$split[0]\t$split[2]\t$split[7]\n";
                        my $temp = $split[2]/$size;
                        $temp = $temp * 100;
                        if ($temp > 50){
#                               print "$code\n";
#                               print "$split[0]\t$split[2]\t$code\n";
                                $hash{$split[0]}{$split[2]}{$split[7]}=$code;
                        }
                }
        }
}

close IN;

open (OUT, ">", "GO_$code.txt");

foreach my $chave1 (keys %hash){
#       print "$chave1\n";
        foreach my $chave2 (keys %{$hash{$chave1}}){
                foreach my $chave3 (keys %{$hash{$chave1}{$chave2}}){
                        print OUT "$chave1\t$chave2\t$chave3\t$hash{$chave1}{$chave2}{$chave3}\n";
                }
        }
}

close OUT;

exit;
