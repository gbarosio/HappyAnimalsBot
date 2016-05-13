#!/usr/bin/perl
# -------------------------------->
use strict;
use Net::Twitter;
use YAML;
use Scalar::Util 'blessed';
use Try::Tiny;
use Data::Dumper;

my $user_to_find = $ARGV[0];

my $consumer_key = '1IkveZAc2FLaCdD7FQv6hZ6gZ';
my $consumer_secret ='g6Dz3jZbQjXAPQ9UZbJTlmfgxgSaC4dNw4d6enjhNm5jbsAyBk';
my $token ='729413218267959296-X7kHPl6RxQQzampE33IB0QWKQgfyeeS';
my $token_secret='XcZ0TlErKkC6fFOibH84owU7i3mtrytgjsRDKoS79oUO3';

my $next_cursor;
my $previous_cursor;

#my $nt = Net::Twitter->new(legacy => 0);
my $nt = Net::Twitter->new(
      traits   => [qw/API::RESTv1_1/],
      consumer_key        => $consumer_key,
      consumer_secret     => $consumer_secret,
      access_token        => $token,
      access_token_secret => $token_secret,
  );

if ($user_to_find) {
	main();
} else {
	status();
}

sub main {
	
	my $cursor = -1;
	my $followers_list;

	try {
		my $followers_list = $nt->followers_ids( {
			screen_name => "$user_to_find",
			cursor => "$cursor",
		} );

		for my $status2 ( @{$followers_list->{ids}} ) {
				print $status2."\n";
		}
	} catch {
		print "Error at main\n";
	}
}

sub status {
	try {
		my $status = $nt->rate_limit_status;
		print Dumper $status;
	} catch {
		print "Error fetching status\n";
	}
}

