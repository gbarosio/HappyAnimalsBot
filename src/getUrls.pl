#!/usr/bin/perl

use strict;
use LWP::UserAgent;

my $filename = 'quotes3.txt';
my ($lines,$chars,$words);

open(my $wiki, '>', 'wikipages.out');
open(my $check, '>', 'checklist.out');

if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
	while (my $row = <$fh>) {
		 $| = 1;
		print "Analyzing $row";
    		chomp $row;

		$chars = 0;
		$words = 0;
		$lines++;

		$chars += length($row);
		$words += scalar(split(/\s+/, $row));
		
		if ($words<2) {
			#print "Fetching wiki page for $row -> ";
			my $url 	= "https://en.wikipedia.org/wiki/$row";
			#print "URL: $url\n";

			
			my $ua  	= LWP::UserAgent->new();
			$ua->max_redirect(2);

			my $content 	= $ua->get($url);

			if ($content->decoded_content =~ m/Animalia/i) {
				print $wiki "Check $url wiki page for details on #$row\n";
			}
		} else {
			print $check "Skipping $row\n";
		}

    	#	print "$lines contain $chars chars and $words words\n";
  	}
	
#	print "Found $lines lines\n";
}
