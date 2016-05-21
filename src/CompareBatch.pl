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

getopts('s:t:',\%options);

print "Source batch: $options{s}\n";
print "Target batch: $options{t}\n";

