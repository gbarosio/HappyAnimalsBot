#!/usr/bin/perl
# finds out followers given a twitter account
# -------------------------------->
use strict;
use Net::Twitter;
use DBI;
use Getopt::Std;
use YAML::XS 'LoadFile';
use Scalar::Util 'blessed';
use Try::Tiny;
use Data::Dumper;
use vars qw/$consumer_secret $consumer_key $token $token_secret %options $nt $dbh $dbname $next_cursor $previous_cursor/;

getopts('aif:b:',\%options);

my $user_to_find 	= $options{f};
my $batch_uuid 		= $options{b};

if ($user_to_find) {
	checkFollowers();
} else {
	print "Missing parameter <user_to_look_up>\n";
}

sub checkFollowers {
	print "Parsing conf\n";
	&parseConf();
	print "Connecting to Twitter and database\n";
	&connect();

	print "Fetching batch UUID";
	my $batch_uuid = getUUID($user_to_find);	
 	my @ids;
	# iterate over twitter's cursor in case of > 5000 followers
	print "Iterating over followers\n";
 	for ( my $cursor = -1, my $r; $cursor; $cursor = $r->{next_cursor} ) {
     		$r = $nt->followers_ids({ screen_name => "$user_to_find",cursor => $cursor });
     		push @ids, @{ $r->{ids} };
 	}

	print "Inserting [$#ids] followers\n";
	foreach (@ids) {
		# one at a time
		insertFollowers($user_to_find,$_,$batch_uuid);	
	}
	print "Updating batch run to true\n";
	updateBatch($batch_uuid);

	sleep(2);
	print "Done\n";
}

sub connect {
	$dbname = "happyanimals";
	try {
	$nt = Net::Twitter->new(
	      traits   => [qw/API::RESTv1_1/],
	      consumer_key        => $consumer_key,
	      consumer_secret     => $consumer_secret,
	      access_token        => $token,
	      access_token_secret => $token_secret,
	  );
	} catch {
		warn "Check $_\n";
	};
	try {
		$dbname = "happyanimals";
		$dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=localhost","gbarosio","qwe123" );
	} catch {
		warn "Check database: $_\n";
	};

}

sub parseConf {
	my $config = LoadFile('/home/gbarosio/HappyAnimalsBot/src/.conf.yml');
	$consumer_key  	= $config->{consumer_key}; 	
	$consumer_secret 	= $config->{consumer_secret};
	$token 		= $config->{access_token};
	$token_secret	= $config->{access_token_secret};
}

sub insertFollowers {
	my $user_to_find = $_[0];
	my $status2 = $_[1];
	my $batch_uuid = $_[2];

	my $query = "INSERT INTO followers (screen_name,follower_id,batch_uuid) values ('$user_to_find',$status2,'$batch_uuid')";
	my $sth = $dbh->prepare($query);
	my @rows = $sth->execute();
}

sub getUUID {
	my $user_to_find = $_[0];
	my $insert = "INSERT INTO batch (screen_name,run) values ('$user_to_find', false)";
	my $sth = $dbh->prepare($insert);
	my @rows = $sth->execute();

	my $query = "SELECT batch_uuid FROM batch WHERE screen_name='$user_to_find' and run = false";
	my $sth = $dbh->prepare($query);

	my @rows = $sth->execute();
	my $return = undef;
	my $return_uuid = undef;

	while ( ($return_uuid ) = $sth->fetchrow() ) {
		$return = $return_uuid;		
	}

	print "UUID: [$return]\n";
	return $return;
}

sub updateBatch {
	my $batch_uuid = $_[0];
	my $update = "UPDATE batch set run = true where batch_uuid = '$batch_uuid'";
	print "$update\n";	
	my $sth = $dbh->prepare($update);	
	$sth->execute();
}
