#!/usr/bin/perl
# -------------------------------->
use strict;
use Net::Twitter;
use YAML;
use Scalar::Util 'blessed';
use Try::Tiny;

my $quote = $ARGV[0];

my $consumer_key = '1IkveZAc2FLaCdD7FQv6hZ6gZ';
my $consumer_secret ='g6Dz3jZbQjXAPQ9UZbJTlmfgxgSaC4dNw4d6enjhNm5jbsAyBk';
my $token ='729413218267959296-X7kHPl6RxQQzampE33IB0QWKQgfyeeS';
my $token_secret='XcZ0TlErKkC6fFOibH84owU7i3mtrytgjsRDKoS79oUO3';

my $nt = Net::Twitter->new(legacy => 0);
my $nt = Net::Twitter->new(
      traits   => [qw/API::RESTv1_1/],
      consumer_key        => $consumer_key,
      consumer_secret     => $consumer_secret,
      access_token        => $token,
      access_token_secret => $token_secret,
  );


# MAIN LOOP
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
	}
}

sub getText {
	my $file = 'quotes.txt';
	open FILE, "<$file" or die "Could not open $file: $!\n";
	my @array=<FILE>;
	close FILE;
	my $randomline=$array[rand @array];
	chomp $randomline;
	return $randomline;
}
