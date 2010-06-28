#!/usr/bin/env perl
# بسم الله الرحمن الرحيم

use utf8;
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Quran;
use Pod::Usage;
use Getopt::Long;

=cut
my ($sura, $ayah, $width, $output, $help) = (undef, undef, undef, 'images/ayahs', 0);

GetOptions(
	'sura:i'  => \$sura,
	'ayah:i'  => \$ayah,
	'width:i'  => \$width,
	'output:s' => \$output,
	'help|?'   => \$help,
) or pod2usage(1); pod2usage(1) if $help;

$output = "$FindBin::Bin/../$output";

my $quran = new Quran;

$quran->image->ayah->generate(
	sura   => $sura,
	ayah   => $ayah,
	width  => $width,
	output => $output
);

=cut
my ($pages, $width, $output, $help) = ('1..604', 1024, 'images', 0);

GetOptions(
	'pages:s'  => \$pages,
	'width:i'  => \$width,
	'output:s' => \$output,
	'help|?'   => \$help,
) or pod2usage(1); pod2usage(1) if $help;

$output = "$FindBin::Bin/../$output";

my @pages = eval $pages;
my $quran = new Quran;

$quran->image->page->generate(
	pages  => [@pages],
	width  => $width,
	output => $output
);

__END__

=head1 NAME

generate.pl - Generate Qur'an Images

=head1 SYNOPSIS

generate.pl --pages [range] --width [width] --output [directory]

	e.g. ./script/generate.pl --pages 1..604 --width 1280 --output ./images
	e.g. ./script/generate.pl --pages 293    --width 640  --output ./images/pages/

=head1 OPTIONS

	-p    --pages    page number or page range to process
	-w    --width    width of image to generate in pixels
	-o    --output   target directory of generated images
	-h    --help     view these helpful instructions

=cut
# vim: ts=2 sw=2 noexpandtab
