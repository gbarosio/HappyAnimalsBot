#!/usr/bin/perl
# TODO:
# -> Setup Getopt::Std
# -> Optimize main algo

use strict;
use Net::Twitter;
use DBI;
use Getopt::Std;
use YAML::XS 'LoadFile';
use Scalar::Util 'blessed';
use Try::Tiny;

use vars qw/$nt $consumer_key $consumer_secret $token $token_secret %options $dbh $dbname/;

getopts('q:',\%options);

if (defined $options{q}) {
	main($options{q});
} else {
	main();
}

sub parseConf {
	my $config;

	try {
		$config = LoadFile('.conf.yml');
	} catch {
		die "could not open conf.yml\n";
	};

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
	};

	try {
		$dbname = "happyanimals";
		$dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=localhost","ha-rw" );
	} catch {
		die "Check database\n";
	};
}



sub main {
	my $quote = $_[0];

	my ($text,$result) = (undef,undef);

	&parseConf;
	&connect();
	my ($animal,$quote)=getQuotes();

	print "$animal,$quote\n";
	$quote = "#$animal, $quote";
	$result = $nt->update($quote);
}

sub getQuotes {
	my $query = "SELECT a.name,q.post from animals a, quotes q where a.id=q.animal_id and  q.flag is false ORDER BY RANDOM() LIMIT 1";

	my $sth = $dbh->prepare($query);

	$sth->execute();

	my ($animal,$quote) = (undef,undef);

	while(my $ref = $sth->fetchrow_hashref()) {
		$animal = $ref->{name};
		$quote  = $ref->{post};
	}

	if ($animal && $quote) {
		return ($animal,$quote);
	}

}

# Extracts a quote from a file, where a line represents each quote
sub getText {
	my $file = 'wikipages.out';
	open FILE, "$file" or die "Could not open $file: $!\n";
	my @array=<FILE>;
#	close FILE;
	my $randomline=$array[rand @array];
	chomp $randomline;
	return $randomline;
}
