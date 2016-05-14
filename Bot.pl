#!/usr/bin/perl
# TODO:
# -> Setup connection to Twitter only when everthing is ready. 
# -> Setup Getopt::Std
# -> Optimize main algo

use strict;
use Net::Twitter;
use Animals;
use Getopt::Std;
use YAML::XS 'LoadFile';
use Scalar::Util 'blessed';
use Try::Tiny;

use vars qw/$nt $consumer_key $consumer_secret $token $token_secret %options/;

getopts('q:',\%options);

if (defined $options{q}) {
	main($options{q});
} else {
	main();
}

sub parseConf {
	my $config = LoadFile('conf.yml');
	$consumer_key  	= $config->{consumer_key}; 	
	$consumer_secret 	= $config->{consumer_secret};
	$token 		= $config->{access_token};
	$token_secret	= $config->{access_token_secret};
}

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



sub main {
	my $quote = $_[0];

	my ($text,$result) = (undef,undef);

	if ($quote) {
		try {
			&parseConf;
			&connect();
			$result = $nt->update($quote);
		} catch {

		}
	} else  {
		$text = getText();
		try {
			&parseConf;
			&connect();
			$result = $nt->update($text);
		} catch {
			die "Error trying to connect at main() with no arguments\n";			
		}
	}
}

# Extracts a quote from a file, where a line represents each quote
sub getText {
	my $file = 'wikipages.out';
	open FILE, "<$file" or die "Could not open $file: $!\n";
	my @array=<FILE>;
	close FILE;
	my $randomline=$array[rand @array];
	chomp $randomline;
	return $randomline;
}
