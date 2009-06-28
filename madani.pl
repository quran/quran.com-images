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
my $dbh = DBI->connect("dbi:SQLite2:dbname=./data/madani.sqlite2.db","","",
	{ RaiseError => 1, AutoCommit => 0 });

use GD;
use GD::Text;
use GD::Text::Align;

use Getopt::Long;
use Pod::Usage;

use List::Util qw/min max/;

my ($page, $batch, $width, $em, $help) = (undef, undef, undef, 1.0, 0);
my $phi = (((sqrt(5)+1)/2) - 1);

my $self = \&main;
bless $self;

GetOptions(
	'page=i' => \$page,
	'batch' => \$batch,
	'width:i' => \$width,
	'em:f' => \$em,
	'help|?' => \$help,
) or pod2usage(1);
pod2usage(1) if $help;

$em = sprintf('%.1f',$em);

die "Minimal parameters are --width and --page for a single page, or \
use --width and --batch to generate images for the entire Qur'an" 
   unless ($width and ($batch or $page));

if ($batch) {
	$self->generate_batch;
}
else {
	$self->generate_page($page);
}

sub generate_batch {
}

sub generate_page {
	my ($self, $page) = @_;

	my %data = ();
	my $longest_line = 0;
	my $longest_width = 0;
	my $page_v = sprintf('%03d', $page);

	my $sth = $dbh->prepare(
		"select line, ayah, text from madani_page_text where page=$page");
	$sth->execute();
	while (my $row = $sth->fetchrow_hashref){
		my @vals = ();
		push(@vals, $row->{ayah});
		push(@vals, $self->_reverse_text($row->{text}));
		$data{$row->{line}} = \@vals;
		my $ayah_w = $self->_get_line_width($vals[1], $page_v, 24);
		if ($ayah_w > $longest_width){
			$longest_width = $ayah_w;
			$longest_line = $row->{line};
		}
	}
	$sth->finish();

	my @ll = @{$data{$longest_line}};
	(my $font_size, $longest_width) = 
		$self->_get_best_font_size($ll[1], $page_v, $longest_width);
  print "got $font_size @ $longest_width\n";

	my $rows = keys(%data);
	my $sub_phi = 1 + ($phi * $phi * $phi);
	my $line_spacing = $font_size * $sub_phi;
	my $padding = $font_size * $phi + ($font_size * $phi * $phi * $phi);
	my $inner_width = $width - (2*$padding);
	my $height = $rows * $font_size + ($rows - 1) * $line_spacing + 2 * $padding;

	my $gd = GD::Image->new($longest_width, $height);
	my $white = $gd->colorAllocate(255, 255, 255);
	my $black = $gd->colorAllocate(0, 0, 0);
	$gd->transparent($white);
	$gd->interlaced('true');

	my $_draw_line = sub {
		my ($i, $ayah, $text) = @_;
		my $align = GD::Text::Align->new(
			$gd, valign => 'top', halign => 'right', color => $black);
		if ((!$ayah) || ($ayah == 0)){
			$align->set_font("./data/fonts/QCF_BSML.TTF", $font_size);
		}
		else {
			$align->set_font("./data/fonts/QCF_P$page_v.TTF", $font_size);
		}
		$align->set_text($text);
		my $coord_x = $inner_width + $padding;
		my $coord_y = $padding * $phi + $i * ($font_size + $line_spacing);
		$coord_y = $i * ($font_size + $line_spacing);
		my @box = $align->bounding_box($coord_x, $coord_y, 0);
		$coord_y += 21;
		$coord_x += $width - max($box[2], $box[4]) - 3;
		$align->draw($coord_x, $coord_y, 0);
	};

	for my $key (sort { $a <=> $b } keys(%data)){
		my $ayah = @{$data{$key}}[0];
		my $line = @{$data{$key}}[1];
		$_draw_line->($key-1, $ayah, @{$data{$key}}[1]);
	}

	open OUTPUT, ">out.png";
	binmode OUTPUT;
	print OUTPUT $gd->png;
}

sub _get_best_font_size {
	my ($self, $text, $page, $longest_width) = @_;

	my $font_step = 1;
	my $font_size = 24;
	my $line_width = $longest_width;

	if ($longest_width > $width){ 
		$font_step = -1;
		while ($line_width > $width){
			$font_size += $font_step;
			$line_width = $self->_get_line_width($text, $page, $font_size);
		}
		return ($font_size, $line_width);
	}
	else {
		my $prev_line_width = 0;
		while ($line_width < $width){
			$font_size += $font_step;
			$prev_line_width = $line_width;
			$line_width = $self->_get_line_width($text, $page, $font_size);
		}
		return ($font_size-$font_step, $prev_line_width);
	}
}

sub _get_line_width {
		my ($self, $text, $page, $font_size) = @_;
		my $gd = GD::Text->new() or die GD::Text::error();
		$gd->set_font("./data/fonts/QCF_P$page.TTF", $font_size) or die $gd->error;
		$gd->set_text($text);

		my $padding = $font_size * $phi + ($font_size * $phi * $phi * $phi);
		my $gdi = GD::Image->new($gd->get('width'), $gd->get('height'));
		my $align = GD::Text::Align->new($gdi, valign => 'top', halign => 'right');
		$align->set_font("./data/fonts/QCF_P$page.TTF", $font_size);
		$align->set_text($text);
		my $coord_x = ($width - (2*$padding)) + $padding;
		my $coord_y = $padding * $phi;
		my @box = $align->bounding_box($coord_x, $coord_y, 0);
		
		return max($box[2], $box[4]) - max($box[0], $box[6]);
}

sub _reverse_text {
	my ($self, $text) = @_;
	my @text = split /;/, $text;
	@text = reverse sort @text;
	$text = join ';', @text;
	$text .= ';';
	return $text;
}


__END__

=head1 NAME

auto.pl - Generate Qur'an Images for Madani pages

=head1 SYNOPSIS

madani.pl --page n --width n [options]


=head1 OPTIONS

	-p    --page     page number to process
	-b    --batch    process the entire Qur'an in one shot
	-w    --width    width of image in pixels
	-e    --em       scale font size by given factor - overrides width
	-h    --help     print this help message and exit

e.g. './madani.pl -p 23 --width=480' would output page 4
     as a png image in the sub 'output' directory.

=cut
# vim: ts=2 sw=2 noexpandtab
