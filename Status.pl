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
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = 1;
use vars qw/$consumer_secret $consumer_key $token $token_secret %options $nt/;

status();

sub status {
	try {
		&parseConf();
		&connect();
		my $status = $nt->rate_limit_status;

		print "Token: ". $status->{rate_limit_context}->{access_token}."\n";
		print "Rate Limit Status: ".$status->{resources}->{application}->{'/application/rate_limit_status'}->{remaining}."\n";
		print "Search limit status: ". $status->{resources}->{search}->{'/search/tweets'}->{remaining}."\n";
		#print Dumper $status;
	} catch {
		print "Error fetching status\n";
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

	print "Here\n";
}

sub parseConf {
	my $config = LoadFile('.conf.yml');
	$consumer_key  	= $config->{consumer_key}; 	
	$consumer_secret 	= $config->{consumer_secret};
	$token 		= $config->{access_token};
	$token_secret	= $config->{access_token_secret};
}
