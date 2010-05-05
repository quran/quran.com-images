#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Quran::Image;

my $image = new Quran::Image;

print $image->page->generate(
	page  => 'all',
	path  => "$FindBin::Bin/../images",
	width => 800
);

1;
