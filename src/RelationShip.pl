#!/usr/bin/perl 

use strict;
use Net::Twitter;
use DBI;
use Getopt::Std;
use YAML::XS 'LoadFile';
use Scalar::Util 'blessed';
use Try::Tiny;
use Data::Dumper;
use vars qw/$consumer_secret $consumer_key $token $token_secret %options $nt/;

getopts('hU:u:',\%options);

my $help 		= $options{h};
my $first_user 		= $options{U};
my $second_user		= $options{u};

help() if ($help || (!$first_user && !$second_user));
if ($first_user && $second_user) {
	main();
}

sub main {
	&parseConf();
	&connect();

	my $var = undef;

	try {
		$var = $nt->show_friendship($first_user,
					   $second_user);
		
	} catch {
		die("Error en main\n");
	};

	my $is_following = $var->{relationship}->{source}->{following};
	my $is_followed  = $var->{relationship}->{source}->{followed_by};
	

	my $id = $var->{relationship}->{source}->{id_str};
	my $can_dm = $var->{relationship}->{source}->{can_dm};
	my $notifications_enabled =  $var->{relationship}->{source}->{notifications_enabled};
	
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

sub help {
	print "$0 -U first -u second\n";
}
