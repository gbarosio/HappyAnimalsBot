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
	&parseConf();
	&connect();

 	my @ids;
	# iterate over twitter's cursor in case of > 5000 followers
 	for ( my $cursor = -1, my $r; $cursor; $cursor = $r->{next_cursor} ) {
     		$r = $nt->followers_ids({ screen_name => "$user_to_find",cursor => $cursor });
     		push @ids, @{ $r->{ids} };
 	}

	foreach (@ids) {
		# one at a time
		insertFollowers($user_to_find,$_);	
	}
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
		$dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=localhost","ha-rw" );
	} catch {
		warn "Check database: $_\n";
	};

}

sub parseConf {
	my $config = LoadFile('.conf.yml');
	$consumer_key  	= $config->{consumer_key}; 	
	$consumer_secret 	= $config->{consumer_secret};
	$token 		= $config->{access_token};
	$token_secret	= $config->{access_token_secret};
}

sub insertFollowers {
	my $user_to_find = $_[0];
	my $status2 = $_[1];

	my $query = "INSERT INTO followers (screen_name,follower_id,batch_uuid) values ('$user_to_find',$status2,'faea0212-1f5e-11e6-a83c-4f9cb81c727e')";
	my $sth = $dbh->prepare($query);
	my @rows = $sth->execute();
}
