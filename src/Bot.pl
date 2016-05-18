#!/usr/bin/perl
# TODO:
# -> update quotes flag as true after tweeting
# -> improve logging mechanisms
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

sub main {
	my $quote = $_[0];

	my ($text,$result) = (undef,undef);

	&parseConf;
	&connect();
	my ($animal,$quote,$id)=getQuotes();

	print "$animal,$quote\n";
	$quote = "#$animal, $quote";
	$result = $nt->update($quote);

	if ( updateQuotesAsFalse($id) && $result ) {
		print "Tweet sent, quotes updated\n";
		exit;
	} else {
		print "Tweet sent, quotes not updated\n";
	}

}

sub updateQuotesAsFalse($) {

	my $id  = $_[0];
	die ("missing ID,cannot update\n") if !$id;
	
	my $query = "UPDATE quotes set flag = true where ID = $id";

	print $query."\n";

	my $sth = $dbh->prepare($query);
	my @rows = $sth->execute();

	if (@rows) {
		print $#rows."<- rows\n";
		return 1;
	} else {
		return 0;
	}
}

sub getQuotes {
	my $query = "SELECT a.name,q.id, q.post from animals a, quotes q where a.id=q.animal_id and  q.flag is not true ORDER BY RANDOM() LIMIT 1";

	my $sth = $dbh->prepare($query);

	$sth->execute();

	my ($animal,$quote,$id) = (undef,undef,undef);

	while(my $ref = $sth->fetchrow_hashref()) {
		$animal = $ref->{name};
		$id	= $ref->{id};
		$quote  = $ref->{post};
	}

	if ($animal && $quote) {
		return ($animal,$quote,$id);
	}

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
