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

use DBI;
use GD;
use GD::Text;
use GD::Text::Align;
#use GD::Text::Wrap;
use Getopt::Long;
use Pod::Usage;
use List::Util qw/min max/;

# we're using Phi because the height/width and width/height ratios of text
# from pages from a madani mushaf are approximately 1.61 and 0.61, respectively
use constant PHI => ((sqrt 5) + 1) / 2;
use constant phi => (((sqrt 5) + 1) / 2) - 1;

my $self = \&main;
bless $self;

my $dbh = DBI->connect("dbi:SQLite2:dbname=./data/madani.sqlite2.db","","",
	{ RaiseError => 1, AutoCommit => 0 });

my ($page, $batch, $width, $scale, $help) = (undef, undef, undef, 1.0, 0);

GetOptions(
	'page=i' => \$page,
	'batch' => \$batch,
	'width:i' => \$width,
	'scale:f' => \$scale,
	'help|?' => \$help,
) or pod2usage(1);
pod2usage(1) if $help;

$scale = sprintf('%.1f',$scale);
my $height = $width * PHI;
my $font_size = $width / 20;
my $line_spacing = ($height - 15 * $font_size) / 15;

die "Minimal parameters are --width and --page for a single page, or --width \
     and --batch for the entire Qur'an" unless $width and ($batch or $page);

if ($batch) {
	$self->generate_batch;
}
else {
	$self->generate_page($page);
}

sub generate_batch {
	for (my $page = 1; $page <= 604; $page++) {
		print "Generating page $page for width $width...\n";
		$self->generate_page($page);
	}
}

sub generate_page {
	my ($self, $page) = @_;

	my $hash = {};
	my $longest_line = 0;
	my $longest_line_width = 0;
	my $page_str = sprintf('%03d', $page);

	my $sth = $dbh->prepare(
		"select line, ayah, text from madani_page_text where page=$page");

	$sth->execute;
	while (my ($line, $ayah, $text) = $sth->fetchrow_array) {
		$text = $self->_reverse_text($text);

		$hash->{$line} = [$ayah, $text];
		my $line_width = $self->_get_line_width($text, $page_str, 24);
		# 24 is an arbitrary font size because we're simply testing to find the longest line
		
		if ($line_width > $longest_line_width) {
			$longest_line = $line;
			$longest_line_width = $line_width;
		}
	}
	$sth->finish;

	my ($ayah, $text) = @{$hash->{$longest_line}};

	my $gd = GD::Image->new($width, $height + $line_spacing / 2);
	my $white = $gd->colorAllocateAlpha(255, 255, 255, 127);
	my $black = $gd->colorAllocate(0, 0, 0);

	$gd->transparent($white);
	$gd->interlaced('false'); # save some kB

	my $_draw_line = sub {
		my ($i, $ayah, $text) = @_;
		my $align = GD::Text::Align->new(
			$gd, valign => 'center', halign => 'center', color => $black);
		if ((!$ayah) || ($ayah == 0)){
			$align->set_font("./data/fonts/QCF_BSML.TTF", $font_size - 1);
		}
		else {
			$align->set_font("./data/fonts/QCF_P$page_str.TTF", $font_size - 1);
		}
		$align->set_text($text);
		my $coord_x = $width / 2;
		my $coord_y = $i * ($font_size + $line_spacing) + $line_spacing;
		my @box = $align->bounding_box($coord_x, $coord_y, 0);
		$align->draw($coord_x, $coord_y, 0);
	};

	for my $line (sort { $a <=> $b } keys %{ $hash }) {
		my $ayah = @{$hash->{$line}}[0];
		my $text = @{$hash->{$line}}[1];
		$_draw_line->($line - 1, $ayah, $text);
	}

	my $path = "./output/width_$width/";
	eval { `mkdir -p $path` };
	open OUTPUT, ">$path/$page_str.png";
	binmode OUTPUT;
	print OUTPUT $gd->png(9); # 0 is highest quality, 9 is highest compression level
} # sub generate_page

sub _get_line_width {
		my ($self, $text, $page, $font_size) = @_;

		my $gd = GD::Text->new() or die GD::Text::error();

		$gd->set_font("./data/fonts/QCF_P$page.TTF", $font_size) or die $gd->error;
		$gd->set_text($text);

		my $gdi = GD::Image->new($gd->get('width'), $gd->get('height'));
		my $align = GD::Text::Align->new($gdi, valign => 'center', halign => 'center');
		$align->set_font("./data/fonts/QCF_P$page.TTF", $font_size);
		$align->set_text($text);
		my @box = $align->bounding_box(0, 0, 0);
		# returns:
		# 0   1   2   3   4   5   6   7
		# x1, y1, x2, y2, x3, y3, x4, y4
		# (x1,y1) lower left corner
		# (x2,y2) lower right corner
		# (x3,y3) upper right corner
		# (x4,y4) upper left corner

		
		# max of lower right corner's x versus upper right corner's x
		# minus
		# min of lower left corner's x verses upper left corner's x
		my $line_width = max($box[2], $box[4]) - min($box[0], $box[6]);
		return $line_width;
} # sub _get_line_width

sub _reverse_text {
	my ($self, $text) = @_;
	my @text = split /;/, $text;
	@text = reverse sort @text;
	$text = join ';', @text;
	$text .= ';';
	return $text;
} # sub _reverse_text


__END__

=head1 NAME

generate.quran.page.pl - Generate Qur'an Images for Madani pages

=head1 SYNOPSIS

generate.quran.page.pl --page n --width n [options]


=head1 OPTIONS

	-p    --page     page number to process
	-b    --batch    process the entire Qur'an in one shot
	-w    --width    width of image in pixels
	-s    --scale    scale font size by given factor - overrides width
	-h    --help     print this help message and exit

e.g. './generate.quran.page.pl -p 23 --width=480' would output page 4
     as a png image in the sub 'output' directory.

=cut
# vim: ts=2 sw=2 noexpandtab
