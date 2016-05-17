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

my $argument = $ARGV[0];

if ($argument) {
	search($argument);
} else {
	die "Argument required at $0\n";
}

sub search {
	try {
		&parseConf();
		&connect();
		my $status = $nt->search("$argument");

		foreach my $e (@{ $status->{statuses} }) {
 			print "$e->{user}{screen_name}:  $e->{text}\n";
		}
	} catch {
		print "Error searching\n";
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
