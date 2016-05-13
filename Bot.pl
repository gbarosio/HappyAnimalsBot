#!/usr/bin/perl
# TODO:
# -> Implement YAML conf parser
# -> Setup connection to Twitter only when everthing is ready. 
# -> Setup Getopt::Std
# -> Optimize main algo

use strict;
use Net::Twitter;
use YAML;
use Scalar::Util 'blessed';
use Try::Tiny;
use DBI;
use vars qw/$nt/;

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);

my $quote = $ARGV[0];

my $consumer_key = '1IkveZAc2FLaCdD7FQv6hZ6gZ';
my $consumer_secret ='g6Dz3jZbQjXAPQ9UZbJTlmfgxgSaC4dNw4d6enjhNm5jbsAyBk';
my $token ='729413218267959296-X7kHPl6RxQQzampE33IB0QWKQgfyeeS';
my $token_secret='XcZ0TlErKkC6fFOibH84owU7i3mtrytgjsRDKoS79oUO3';

&connect();
&loop();

sub connect {

	try {
		$nt = Net::Twitter->new(
		      traits   => [qw/API::RESTv1_1/],
		      consumer_key        => $consumer_key,
		      consumer_secret     => $consumer_secret,
		      access_token        => $token,
		      access_token_secret => $token_secret,
		);
	} catch {
		die "Check connection\n";
	}

}

if ($quote) {
	main($quote);
} else {
	main();
}


sub main {
	my ($text,$result) = (undef,undef);

	if ($quote) {
		$result = $nt->update($quote);
	} else  {
		$text = getText();
		$result = $nt->update($text);
	}
}

# Extracts a quote from a file, where a line represents each quote
sub getText {
	my $file = 'quotes.txt';
	open FILE, "<$file" or die "Could not open $file: $!\n";
	my @array=<FILE>;
	close FILE;
	my $randomline=$array[rand @array];
	chomp $randomline;
	return $randomline;
}
