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

# TODO
# fix varying vertical space between lines

use strict;
use warnings;

use DBI;
use GD;
use GD::Text;
use GD::Text::Align;
use GD::Text::Wrap;
use Getopt::Long;
use Pod::Usage;
use List::Util qw/min max/;

my $self = \&main;
bless $self;

my $dbh = DBI->connect("dbi:SQLite2:dbname=./data/text.copy.copy.copy.sqlite2.db","","",
	{ RaiseError => 1, AutoCommit => 0 });

my ($sura, $ayah, $batch, $width, $scale, $help) = (undef, undef, undef, 640, 1.0, 0);

GetOptions(
	'surah=i' => \$sura,
	'ayah=i' => \$ayah,
	'batch' => \$batch,
	'width:i' => \$width,
	'scale:f' => \$scale,
	'help|?' => \$help,
) or pod2usage(1);
pod2usage(1) if $help;

$scale = sprintf('%.2f',$scale);

die "Minimal parameters are both --sura and --ayah for a single verse, or use \
     --batch to generate images for the entire Qur'an" unless $batch or ($sura and $ayah);

if ($batch) {
	$self->generate_batch;
}
else {
	$self->generate_image($sura, $ayah);
}

sub generate_batch {
	my $sth = $dbh->prepare(
		"select sura, ayah from sura_ayah_page_text order by sura asc, ayah asc");
	$sth->execute;
	while (my @row = $sth->fetchrow_array) {
		$self->generate_image(@row);
	}
	$sth->finish;
}

sub generate_image {
	my ($self, $sura, $ayah) = @_;

	print "Generating image for sura $sura, ayah $ayah...\n";

	my ($page, $text) = $dbh->selectrow_array(
		"select page, text from sura_ayah_page_text where sura = $sura and ayah = $ayah");

=cut
	my @text = split /;/, $text;
	pop @text; # remove ayah glyph
	my $hizb = $dbh->selectrow_array(
		"select hizb from sura_ayah_info where sura = $sura and ayah = $ayah");
	shift @text if $hizb;
	$text = join ';', @text;
	$text .= ';' if $text !~ /;$/;
=cut

	$text = $self->_reverse_text($text);
	$page = sprintf('%03d', $page);

	my $font_size = ($width / 20) * $scale;
	if ($page == 1 || $page == 2) {
		$font_size = $font_size * (4/3);
	}
	my $line_spacing = $font_size;

	# we're going to adjust a problem with spacing between words where line breaks occur in a mushaff
	my ($last_line, $line_count) = $dbh->selectrow_array(
		"select max(line), count(*) from madani_page_text where sura = $sura and ayah = $ayah");
	my $sth = $dbh->prepare(
		"select line, text from madani_page_text where sura = $sura and ayah = $ayah order by line asc");
	$sth->execute;
	while (my ($line_number, $line_text) = $sth->fetchrow_array) {
		$line_text = $self->_reverse_text($line_text);
		if ($line_number < $last_line) {
			$text =~ s/$line_text/&#32;&#32;$line_text&#32;&#32;/g; # add spaces around that segment of text
		}
		# else, if the ayah is supposedly on a single line but the
		# line's text doesn't contain all of that ayah's text
		# then we know it actually spans two lines and also needs some
		# spacing added around segments
		elsif ($line_count == 1 and $line_text !~ $text) {
			# we're going to remove word's if the ayah's text doesn't have it
			my @line_text = split /;/, $line_text;
			my $shift_count = 0;
			for (my $i = 0; $i < @line_text; $i++) {
				if ($text !~ $line_text[$i]) {
					$shift_count++;
				}
				else {
					last;
				}
			}
			for (my $i = 0; $i < $shift_count; $i++) {
				shift @line_text;
			}
			$line_text = join ';', @line_text;
			$line_text .= ';';
			$text =~ s/$line_text/$line_text&#32;&#32;/g; # add spaces around that segment of text
		}
	}
	$text =~ s/^(&#32;)+//;
	$text =~ s/(&#32;)+$//;
	$text =~ s/(&#32;)+/&#32;&#32;/g;
	$sth->finish;

  my $gd_text = GD::Text->new() or die GD::Text::error();

	$gd_text->set_font("./data/fonts/QCF_P$page.TTF", $font_size) or die $gd_text->error;
  $gd_text->set_text($text);

  my $text_width = $gd_text->get('width');

	my $_wrap_text = sub { # sub-routine for wrapping the text
		my $_text = shift;
		my @line = split /\n/, $_text; # if you're wondering where this comes from see the line right above this function's return statement
		my %max = (
			width => 0,
			line  => 0
		);

		for (my $i = 0; $i < @line; $i++) {
			my $_text = $line[$i];

			$gd_text->set_text($_text);

			my $_text_width = $gd_text->get('width');
			my $_text_height = $gd_text->get('height');

			if ($_text_width > $max{width}) {
				$max{width} = $_text_width;
				$max{line}  = $i;
			}
		}

		my @this_line = split /;/, $line[$max{line}];
		my $word = shift @this_line; # remove and store the last word from the longest line

		$line[$max{line}] = join ';', @this_line; # reconstruct the line which we just shifted a word from
		$line[$max{line}] .= ';';

		my $next_line_index = $max{line} + 1;
		if (scalar(@line) > $next_line_index) { # if a next line exists
			my @next_line = split /;/, $line[$next_line_index];

			push @next_line, $word; # then put the word on the next line

			$line[$next_line_index] = join ';', @next_line;
			$line[$next_line_index] .= ';';
		}
		else { # otherwise we need to push a new line
			$word .= ';';
			push @line, $word;
		}

		$_text = join "\n", @line;
		return $_text;
	};

	while ($text_width > $width) { # wrap the text ONLY if the text width exceeds our maximum specified ($width)
		$text = $_wrap_text->($text);
		$gd_text->set_text($text);
		$text_width = $gd_text->get('width');
	}

	my @line = split /\n/, $text;
	my $lines = scalar @line;

	for (my $i = 0; $i < $lines; $i++) {
		my $_text = $line[$i];
		$_text =~ s/^(&#32;)+//; # get rid of any spaces at the beginning and end of the line
		$_text =~ s/(&#32;)+$//; # if these accidentally ended up there
		$line[$i] = $_text;
	}

	if ($lines > 1) { # don't let ayah number sit on a line by itself
		my @last_line = split /;/, $line[$lines - 1];
		my $words_on_last_line = scalar(@last_line);

		if ($words_on_last_line == 1) {
			my @line_before_last_line = split /;/, $line[$lines - 2];
			my $word = shift @line_before_last_line;

			push @last_line, $word; # put the last word from the line before the last line on the last line instead

			$line[$lines - 2] = join ';', @line_before_last_line;
			$line[$lines - 2] .= ';';
		}

		$line[$lines - 1] = join ';', @last_line;
		$line[$lines - 1] .= ';';
	}
	$text = join "\n", @line;

	my $height = $lines * $font_size + ($lines - 1) * $line_spacing;

	my $hack_width = 3 * $width; # let's make it big
	my $hack_height = 3 * $height;

	my $gd_image = GD::Image->new($hack_width, $hack_height);
	my $gd_image_white = $gd_image->colorAllocate(255,255,255);

	$gd_image->transparent($gd_image_white);
	$gd_image->interlaced('false');

	my $cumulative_y = 0;
	my $last_base_line = 0;
	my $_draw_line = sub { # a sub-routine to draw lines
		my ($i, $_text) = @_;

		my $hack_width = 2 * $width;
		my $hack_height = 3 * $line_spacing;

		my $gd_image_hack = GD::Image->new($hack_width, $hack_height);
		my $gd_image_hack_white = $gd_image_hack->colorAllocate(255,255,255);
		my $gd_image_hack_black = $gd_image_hack->colorAllocate(0,0,0);

		$gd_image_hack->transparent($gd_image_hack_white);
		$gd_image_hack->interlaced('false');

		my $gd_text_align = GD::Text::Align->new($gd_image_hack,
			valign => 'top',
			halign => 'right',
			color  => $gd_image_hack_black,
		);

		$gd_text_align->set_font("./data/fonts/QCF_P$page.TTF", $font_size);
		$gd_text_align->set_text($_text);

		my $coord_x = 1.5 * $width;
		my $coord_y = $line_spacing;# + $cumulative_y;

		$gd_text_align->draw($coord_x, $coord_y, 0);

		my ($min_x, $min_y, $max_x, $max_y) = ($hack_width, $hack_height, 0, 0);

		my @pixel_count;

		for (my $x = 0; $x <= $hack_width; $x++) {
			for (my $y = 0; $y <= $hack_height; $y++) {
				$pixel_count[$y] = 0 if !$pixel_count[$y];
				if ($gd_image_hack->getPixel($x, $y)) {
					$pixel_count[$y]++;
					$min_x = $x if $x < $min_x;
					$min_y = $y if $y < $min_y;
					$max_x = $x if $x > $max_x;
					$max_y = $y if $y > $max_y;
				}
			}
		}

		my $base_line = 0;
		my $max_pixels = 0;

		for (my $i = 0; $i < $min_y; $i++) {
			shift @pixel_count;
		}
		for (my $i = $max_y + 1; $i <= $hack_height; $i++) {
			pop @pixel_count;
		}
		for (my $y = 0; $y < @pixel_count; $y++) {
			if ($pixel_count[$y] > $max_pixels) {
				$max_pixels = $pixel_count[$y];
				$base_line = $y;
			}
		}

		$gd_image->copy($gd_image_hack,
			$width - ($max_x - $min_x + 1), $cumulative_y, # destination x, y
			$min_x, $min_y, # source x, y
			$max_x - $min_x + 1, $max_y - $min_y + 1 # source w, h
		);

		$cumulative_y += $line_spacing + $base_line;

		undef $gd_image_hack;
		undef $gd_text_align;
	};

	for (my $i = 0; $i < @line; $i++) {
		my $_text = $line[$i];
		$_draw_line->($i, $_text);
	}

	my ($min_x, $min_y, $max_x, $max_y) = ($hack_width, $hack_height, 0, 0);

	for (my $x = 0; $x <= $hack_width; $x++) {
		for (my $y = 0; $y <= $hack_height; $y++) {
			if ($gd_image->getPixel($x, $y)) {
				$min_x = $x if $x < $min_x;
				$min_y = $y if $y < $min_y;
				$max_x = $x if $x > $max_x;
				$max_y = $y if $y > $max_y;
			}
		}
	}

	my $gd_image_final = GD::Image->new($width, $max_y - $min_y + 1);
	my $gd_image_final_white = $gd_image_final->colorAllocate(255,255,255);

	$gd_image_final->transparent($gd_image_final_white);
	$gd_image_final->interlaced('false');

	$gd_image_final->copy($gd_image,
		$width - ($max_x - $min_x + 1), 0, # destination x, y
		$min_x, $min_y, # source x, y
		$max_x - $min_x + 1, $max_y - $min_y + 1 # source w, h
	);

	my $path = './output/width_'. $width .'/em_'. $scale .'/';
	my $file = $sura ."_". $ayah .".png";

	eval { `mkdir -p $path` };
	open OUTPUT, ">". $path . $file;
	binmode OUTPUT;
	print OUTPUT $gd_image_final->png(9);
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

generate.quran.ayah.pl - Generate Qur'an Images for Ayahs

=head1 SYNOPSIS

generate.quran.ayah.pl --sura n --ayah n [options]


=head1 OPTIONS

	-s    --sura     sura number to process
	-a    --ayah     ayah number to process
	-b    --batch    process the entire Qur'an in one shot
	-w    --width    width of image in pixels
	-e    --em       scale font size by given factor
	-h    --help     print this help message and exit

e.g. './generate.quran.ayah.pl -s 2 -a 255 --width=480 --em=0.9' would output Ayah
     Al-Kursi (2:255) as a png image in the sub 'output' directory.

i.e. './output/width_480/em_0.9/2_255.png' the image for 480 pixels
     at 90% font size.

=cut
# vim: ts=2 sw=2 noexpandtab
