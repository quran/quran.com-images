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
use GD::Text::Wrap;
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
my $dbh2 = DBI->connect("dbi:SQLite2:dbname=./data/sura_ayah_page_text.sqlite2.db","","",
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

$scale = sprintf('%.1f',$scale);
my $font_size = $width / 20;
$font_size *= $scale;
my $line_spacing = $font_size; #($height - 15 * $font_size) / 15;

die "Minimal parameters are both --sura and --ayah for a single verse, or use \
     --batch to generate images for the entire Qur'an" unless $batch or ($sura and $ayah);

if ($batch) {
	$self->generate_batch;
}
else {
	$self->generate_image($sura, $ayah);
}

sub generate_batch {
	my $sth = $dbh2->prepare(
		"select sura, ayah from sura_ayah_page_text order by sura asc, ayah asc");
	$sth->execute;
	while (my @row = $sth->fetchrow_array) {
		$self->generate_image(@row);
	}
	$sth->finish;
}

sub generate_image {
	my ($self, $sura, $ayah) = @_;
	my ($page, $text) = $dbh2->selectrow_array(
		"select page, text from sura_ayah_page_text where sura = $sura and ayah = $ayah");
	$text =~ s/[\r\n]+//g;
	my @text = split /;/, $text;
	pop @text; # remove ayah glyph
	my $hizb = $dbh2->selectrow_array(
		"select hizb from sura_ayah_info where sura = $sura and ayah = $ayah");
	if ($hizb) { # remove hizb mark
		shift @text;
	}
	$text = join ';', @text;
	$text .= ';' if $text !~ /;$/;
	$text = $self->_reverse_text($text);

	my $_last_line = $dbh->selectrow_array(
		"select max(line) from madani_page_text where sura = $sura and ayah = $ayah");
	my $sth = $dbh->prepare(
		"select line, text from madani_page_text where sura = $sura and ayah = $ayah order by line asc");
	$sth->execute;
	while (my ($_line, $_text) = $sth->fetchrow_array) {
		$_text =~ s/[\r\n]+//g;
		$_text = $self->_reverse_text($_text);
		if ($_line < $_last_line) {
			$text =~ s/$_text/&#32;&#32;$_text&#32;&#32;/g;
			#print "text vs _text:\n$text\n$_text\n";
		}
	}
	$sth->finish;

	$page = sprintf('%03d', $page);

  my $gd_text = GD::Text->new() or die GD::Text::error();

	$gd_text->set_font("./data/fonts/QCF_P$page.TTF", $font_size) or die $gd_text->error;
  $gd_text->set_text($text);

  my $gd_text_width = $gd_text->get('width');

	my $_wrap_text = sub {
		my $text = shift;
		my @line = split /\n/, $text; # hmm...
		my %longest = (
			width => 0,
			line  => 0
		);
		for (my $i = 0; $i < @line; $i++) {
			my $line_text = $line[$i];
			$gd_text->set_text($line_text);
			my $_gd_text_width = $gd_text->get('width');
			my $_gd_text_height = $gd_text->get('height');
			my $gd = GD::Image->new($_gd_text_width, $_gd_text_height);
			my $align = GD::Text::Align->new($gd,
				valign => 'center',
				halign => 'right'
			);
			$align->set_font("./data/fonts/QCF_P$page.TTF", $font_size);
			$align->set_text($line_text);
			my @box = $align->bounding_box($_gd_text_width, 0, 0);
			$_gd_text_width = max($box[2], $box[4]) - min($box[0], $box[6]);
			do {
				$longest{width} = $_gd_text_width;
				$longest{line}  = $i;
			} if ($_gd_text_width > $longest{width});
		}
		my @line_text = split /;/, $line[$longest{line}];
		my $word = shift @line_text;
		$line[$longest{line}] = join ';', @line_text;
		$line[$longest{line}] .= ';';
		my $i_plus = $longest{line} + 1;
		if (@line > $i_plus) {
			my @next_line_down = split /;/, $line[$i_plus];
			push @next_line_down, $word;
			$line[$i_plus] = join ';', @next_line_down;
			$line[$i_plus] .= ';';
		}
		else {
			$word .= ';';
			push @line, $word;
		}

		$text = join "\n", @line;
		return $text;
	};
	while ($gd_text_width > $width) {
		$text = $_wrap_text->($text);
		$gd_text->set_text($text);
		$gd_text_width = $gd_text->get('width');
	}
	my @line = split /\n/, $text;
	my $lines = scalar @line;
	my $height = $lines * $font_size + ($lines - 1) * $line_spacing;


	my $width_hack = $width + $line_spacing;
	my $height_hack = $height + 2 * $line_spacing;

	my $gd = GD::Image->new($width_hack, $height_hack);
	my $white = $gd->colorAllocate(255,255,255);
	my $black = $gd->colorAllocate(0,0,0);
	$gd->transparent($white);
	$gd->interlaced('false'); # maybe set true for anti-aliasing--test it

	my $_draw_line = sub {
		my ($i, $text) = @_;
		my $align = GD::Text::Align->new($gd,
			valign => 'top',
			halign => 'right',
			color  => $black,
		);
		$align->set_font("./data/fonts/QCF_P$page.TTF", $font_size);
		$align->set_text($text);
		#print "$font_size $line_spacing\n";
		my $coord_x = $width;
		my $coord_y = $line_spacing + $i * ($font_size + $line_spacing);
		my @box = $align->bounding_box($coord_x, $coord_y, 0);
		$align->draw($coord_x, $coord_y, 0);
	};

	for (my $i = 0; $i < @line; $i++) {
		my $text = $line[$i];
		$text =~ s/^(&#32;)+//;
		$text =~ s/(&#32;)+$//;
		$_draw_line->($i, $text);
	}

	my $min_x = $width_hack;
	my $min_y = $height_hack;
	my $max_x = 0;
	my $max_y = 0;

	for (my $x = 0; $x <= $width_hack; $x++) {
		for (my $y = 0; $y <= $height_hack; $y++) {
			if ($gd->getPixel($x, $y)) {
				$min_x = $x if $x < $min_x;
				$min_y = $y if $y < $min_y;
				$max_x = $x if $x > $max_x;
				$max_y = $y if $y > $max_y;
			}
		}
	}

	my $gd_hack = GD::Image->new($width, $max_y - $min_y);
	my $gd_hack_white = $gd_hack->colorAllocate(255,255,255);
	$gd_hack->transparent($gd_hack_white);
	$gd_hack->interlaced('false'); # maybe set true for anti-aliasing--test it
	$gd_hack->copy($gd, $width - ($max_x - $min_x), 0, $min_x, $min_y, $max_x - $min_x, $max_y - $min_y);
	#$gd_hack->copy($gd, 0, 0, 100, 100, 100, 100);

	my $path = './output/width_'. $width .'/em_'. $scale .'/';
	my $file = $sura ."_". $ayah .".png";
	eval { `mkdir -p $path` };
	open OUTPUT, ">". $path . $file;
	binmode OUTPUT;
	print OUTPUT $gd_hack->png(9);
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
