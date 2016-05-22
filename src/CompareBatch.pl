#!/usr/bin/perl
# finds out followers given a twitter account
# -------------------------------->
use strict;
use Net::Twitter;
use List::Compare;
use DBI;
use Getopt::Std;
use YAML::XS 'LoadFile';
use Scalar::Util 'blessed';
use Try::Tiny;
use Data::Dumper;
use vars qw/$consumer_secret $consumer_key $token $token_secret %options $nt $dbh $dbname $next_cursor $previous_cursor/;

getopts('s:t:',\%options);

print "Source batch: $options{s}\n";
print "Target batch: $options{t}\n";

my $source = $options{s};
my $target = $options{t};

&parseConf();
&connect();
&compare($source,$target);

sub compare {
	my @followers_ori = undef;
	my @followers_new = undef;

	my $query = "SELECT follower_id FROM followers WHERE batch_uuid = '$source'";
	my $sth = $dbh->prepare($query);
	my @rows = $sth->execute();

	my ($follower_id);

	$sth->bind_col(1,\$follower_id);

	while ($sth->fetch) {
		push(@followers_ori,$follower_id);
	}

	my $query = "SELECT follower_Id FROM followers WHERE batch_uuid ='$target'";
	my $sth	= $dbh->prepare($query);
	my @rows = $sth->execute();

	$follower_id = undef;
	$sth->bind_col(1,\$follower_id);

	while ($sth->fetch) {
		push(@followers_new,$follower_id);
	}

	my $lc = List::Compare->new('-u',\@followers_ori,\@followers_new);

	my @Lonly = $lc->get_unique;
	my @Ronly = $lc->get_complement;

	print "Original batch size: $#followers_ori\n";
	print "Lonly $#Lonly\n";
	foreach (@Lonly) {
		print "Left: $_\n";
	}

	print "Target batch size: $#followers_new\n";
	print "Ronly $#Ronly\n";
	foreach (@Ronly) {
		print "Joined: $_\n";
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
