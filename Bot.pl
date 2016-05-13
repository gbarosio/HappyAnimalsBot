#!/usr/bin/perl
# TODO:
# -> Implement YAML conf parser
# -> Setup connection to Twitter only when everthing is ready. 
# -> Setup Getopt::Std
# -> Optimize main algo

#use strict;
use Net::Twitter;
use YAML::XS 'LoadFile';
use Scalar::Util 'blessed';
use Try::Tiny;
use Data::Dumper;
use DBI;
use vars qw/$nt $consumer_key $consumer_secret $token $token_secret/;

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);

my $quote = $ARGV[0];

&parseConf();
&connect();

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
		print "Not tweeted: $text\n";
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
