#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;

#blast result - tabular format
my $file = $ARGV[0];
my (%query,%final,@unip);

#print "$file\n";

open (IN, "<", $file);

foreach my $line (<IN>){
	chomp $line;
	my @split = split (/\t/,$line);
	#Evalue 1e-3
	if ($split[10] < 0.01){
		$query{$split[0]}{$split[1]}{$split[10]}=$split[11];
	}
}

close IN;

foreach my $chave1 (keys %query){
	my ($hit, $menor, @maior);
	foreach my $chave2 (keys %{$query{$chave1}}){
		foreach my $chave3 (sort keys %{$query{$chave1}{$chave2}}){
			push @maior, $chave3;
		}
		for (my $a = 0; $a <= $#maior; $a++){
			if (($#maior > 0)){
				if (($a+1 <= $#maior) && ($maior[$a] > $maior[$a+1])){
					$menor = $maior[$a+1];
				}
				elsif (($a+1 <= $#maior) && ($maior[$a] < $maior[$a+1])) {
					$menor = $maior[$a];
				}
			}
			elsif (($#maior == 0)){
				$menor = $maior[$a];
			}
		}
		$hit = $chave2;
	}
	$final{$chave1}{$hit}=$menor if (length ($menor) > 0);
}

open (OUT, ">", "teste.out");
foreach my $result1 (keys %final){
	foreach my $result2 (sort keys %{$final{$result1}}){
		my @split = split (/\|/,$result2);
		push @unip, $split[1];
		print OUT"$result1\t$split[1]\t$final{$result1}{$result2}\n";
	}
}
close OUT;

my $base = 'https://www.uniprot.org';
my $tool = 'uploadlists';

my $scalar = join (" ", @unip);
$scalar = "\'" . $scalar . "\'";

open (OUT2, ">", "temp.out");
my $params = {
  from => 'ACC',
  to => 'GENENAME',
  format => 'tab',
  query => $scalar
};
my $contact = ''; # Please set a contact email address here to help us debug in case of problems (see https://www.uniprot.org/help/privacy).
my $agent = LWP::UserAgent->new(agent => "libwww-perl $contact");
push @{$agent->requests_redirectable}, 'POST';
my $response = $agent->post("$base/$tool/", $params);
while (my $wait = $response->header('Retry-After')) {
	 #print STDERR "Waiting ($wait)...\n";
	 sleep $wait;
	 $response = $agent->get($response->base);
}
$response->is_success ?
print OUT2 $response->content :
die 'Failed, got ' . $response->status_line .
' for ' . $response->request->uri . "\n";

close OUT2;

open (IN2, "<", "temp.out");
open (OUT3, ">", "temp2.out");
foreach my $line (<IN2>){
	chomp $line;
	if ($line !~ /From\s{1,}To/i){
		#print "$line\t\t";
		my @split2 = split (/\t/,$line);
		foreach my $result1 (keys %final){
			foreach my $result2 (sort keys %{$final{$result1}}){
				my @split = split (/\|/,$result2);
				if ($split[1] eq $split2[0]){
					print OUT3 "$result1\t$line\t$final{$result1}{$result2}\n";
				}
			}
		}
	}
}

close IN2;
close OUT3;

system ('echo "Prot,Hit_Uniprot,Gene,Evalue" | sed \'s/,/\t/g\' > header');
system ('cat header temp2.out > input_cytos.txt');
system ('rm header temp.out temp2.out');

exit;
