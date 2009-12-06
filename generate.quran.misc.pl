#!/usr/bin/env perl
# بسم الله الرحمن الرحيم
# In the name of Allah, Most Gracious, Most Merciful

# Quran Image Generator
#  Using primary source fonts originating from the King Fahed Complex in Saudi Arabia...
#  <em>As seen on Quran.com</em>

# Authors/Contributors
#  Ahmed El-Helw
#  Nour Sharabash

# The code is copyleft GPL (read: free) but the actual fonts and pages (in the 'data' 
# directory) belong to the King Fahed Complex in Saudia Arabia
# Their URL: http://www.qurancomplex.com

use strict;
use warnings;

use GD;
use GD::Text;
use GD::Text::Align;
use Getopt::Long;
use Pod::Usage;
use List::Util qw/min max/;

my ($width, $scale, $fg, $bg, $bismillah, $suras) = (675, 1.0, '000000', 'ffffff', 1, 1);

GetOptions(
	'width:i' => \$width,
	'scale:f' => \$scale,
	'fg:s' => \$fg,
	'bg:s' => \$bg,
	'bismillah!' => \$bismillah,
	'suras!' => \$suras
) or pod2usage(1);

my ($fg_red, $fg_green, $fg_blue, $bg_red, $bg_green, $bg_blue) = (0, 0, 0, 255, 255, 255);

$fg =~ s/^#//;
my @fg = split //, $fg;
if (scalar(@fg) == 6) {
	$fg_red = shift(@fg) . shift(@fg);
	$fg_green = shift(@fg) . shift(@fg);
	$fg_blue = shift(@fg) . shift(@fg);
	$fg_red = hex($fg_red);
	$fg_green = hex($fg_green);
	$fg_blue = hex($fg_blue);
}

$bg =~ s/^#//;
my @bg = split //, $bg;
if (scalar(@bg) == 6) {
	$bg_red = shift(@bg) . shift(@bg);
	$bg_green = shift(@bg) . shift(@bg);
	$bg_blue = shift(@bg) . shift(@bg);
	$bg_red = hex($bg_red);
	$bg_green = hex($bg_green);
	$bg_blue = hex($bg_blue);
}

$scale = sprintf('%.2f',$scale);

my $font_size = ($width / 20) * $scale;
my $height = 2 * $font_size;
my $path = "./output/width_$width/em_$scale/misc";


if ($bismillah) {
	my $gd = GD::Image->new($width, $height);
	my $gd_white = $gd->colorAllocate($bg_red, $bg_green, $bg_blue);
	my $gd_color = $gd->colorAllocate($fg_red, $fg_green, $fg_blue);
	$gd->transparent($gd_white);
	$gd->interlaced('false'); # save some kB
	my $align = GD::Text::Align->new($gd,
		valign => 'center', halign => 'center', color => $gd_color);
	$align->set_font("./data/fonts/QCF_BSML.TTF", $font_size);
	$align->set_text("&#64339;&#64338;&#64337;");
	$align->draw($width / 2, $font_size / 2, 0);

	my ($min_x, $min_y, $max_x, $max_y) = ($width, $height, 0, 0);

	for (my $x = 0; $x <= $width; $x++) {
		for (my $y = 0; $y <= $height; $y++) {
			if ($gd->getPixel($x, $y)) {
				$min_x = $x if $x < $min_x;
				$min_y = $y if $y < $min_y;
				$max_x = $x if $x > $max_x;
				$max_y = $y if $y > $max_y;
			}
		}
	}
	my $gd_image = GD::Image->new($max_x - $min_x + 2, $max_y - $min_y + 2);
	my $gd_image_white = $gd_image->colorAllocate($bg_red, $bg_green, $bg_blue);
	$gd_image->transparent($gd_image_white);
	$gd_image->interlaced('false'); # save some kB

	$gd_image->copy($gd,
		0, 0, # destination x, y
		$min_x, $min_y, # source x, y
		$max_x - $min_x + 1, $max_y - $min_y + 1 # source w, h
	);

	print "Generating image for bismillah...\n";

	eval { `mkdir -p $path` };
	open OUTPUT, ">$path/bismillah.png";
	binmode OUTPUT;
	print OUTPUT $gd_image->png(9); # 0 is highest quality, 9 is highest compression level
}

if ($suras) {
	my %hash = ();
	my $base = 64396;
	for (my $i = 1; $i <= 37; $i++) {
		my $id = $base + $i;
		my $key = $i;
		$hash{$key} = $id;
	}
	for (my $i = 38; $i <= 114; $i++) {
		my $id = $base + 33 + $i;
		my $key = $i;
		$hash{$key} = $id;
	}
	for (sort keys %hash) {
		my $sura = $_;
		my $id = $hash{$sura};
		print "Generating image for sura $sura...\n";


		my $_width = 2 * $width;
		my $_height = 2 * $height;

		my $gd = GD::Image->new($_width, $_height);
		my $gd_white = $gd->colorAllocate($bg_red, $bg_green, $bg_blue);
		my $gd_color = $gd->colorAllocate($fg_red, $fg_green, $fg_blue);
		$gd->transparent($gd_white);
		$gd->interlaced('false'); # save some kB
		my $align = GD::Text::Align->new($gd,
			valign => 'center', halign => 'center', color => $gd_color);
		$align->set_font("./data/fonts/QCF_BSML.TTF", $font_size);
		$align->set_text("&#$id;&#$base;");
		$align->draw($_width / 2, $_height / 2, 0);

		my ($min_x, $min_y, $max_x, $max_y) = ($_width, $_height, 0, 0);
		for (my $x = 0; $x <= $_width; $x++) {
			for (my $y = 0; $y <= $_height; $y++) {
				if ($gd->getPixel($x, $y)) {
					$min_x = $x if $x < $min_x;
					$min_y = $y if $y < $min_y;
					$max_x = $x if $x > $max_x;
					$max_y = $y if $y > $max_y;
				}
			}
		}
		my $gd_image = GD::Image->new($max_x - $min_x + 2, $max_y - $min_y + 2);
		my $gd_image_white = $gd_image->colorAllocate($bg_red, $bg_green, $bg_blue);
		$gd_image->transparent($gd_image_white);
		$gd_image->interlaced('false'); # save some kB

		$gd_image->copy($gd,
			1, 1, # destination x, y
			$min_x, $min_y, # source x, y
			$max_x - $min_x + 1, $max_y - $min_y + 1 # source w, h
		);

		open OUTPUT, ">$path/$sura.png";
		binmode OUTPUT;
		print OUTPUT $gd_image->png(9); # 0 is highest quality, 9 is highest compression level
	}
}
# vim: ts=2 sw=2 noexpandtab
