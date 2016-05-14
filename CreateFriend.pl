#!/usr/bin/perl
# finds out followers given a twitter account
# -------------------------------->
use strict;
use Net::Twitter;
use Animals;
use YAML::XS 'LoadFile';
use Scalar::Util 'blessed';
use Try::Tiny;
use Data::Dumper;
use vars qw/$consumer_secret $consumer_key $token $token_secret %options $nt/;

my $user_to_add = $ARGV[0];

my $next_cursor;
my $previous_cursor;


if ($user_to_add) {
	main();
}

sub main {
	&parseConf();
	&connect();
	my $followers_list;

	try {
		$nt->create_friend($user_to_add);
	} catch {
		print "Error creating friendship\n";
	}
}

sub connect {
	$nt = Net::Twitter->new(
	      traits   => [qw/API::RESTv1_1/],
	      consumer_key        => $consumer_key,
	      consumer_secret     => $consumer_secret,
	      access_token        => $token,
	      access_token_secret => $token_secret,
	  );
}

sub parseConf {
	my $config = LoadFile('.conf.yml');
	$consumer_key  	= $config->{consumer_key}; 	
	$consumer_secret 	= $config->{consumer_secret};
	$token 		= $config->{access_token};
	$token_secret	= $config->{access_token_secret};
}
