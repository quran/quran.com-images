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
use Getopt::Long;
use Pod::Usage;
use List::Util qw/min max/;

# we're using Phi because the height/width and width/height ratios of text
# from pages from a madani mushaf are approximately 1.61 and 0.61, respectively
use constant PHI => ((sqrt 5) + 1) / 2;
use constant phi => (((sqrt 5) + 1) / 2) - 1;

my $self = \&main;
bless $self;

my $dbh = DBI->connect("dbi:SQLite2:dbname=./data/text.sqlite2.db","","",
	{ RaiseError => 1, AutoCommit => 0 });

# for now, but we can move it to the same database...
my $corpus_dbh = DBI->connect(
	"dbi:SQLite2:dbname=./data/corpus/corpus.sqlite2.db","","",
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
		print "-- Generating page $page for width $width...\n";
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
	my $red = $gd->colorAllocate(255, 0, 0);

	$gd->transparent($white);
	$gd->interlaced('false'); # save some kB

	my $_draw_line = sub {
		my ($i, $ayah, $text) = @_;
		my @words = split(/;/, $text);

		if ((!$ayah) || ($ayah == 0)){ @words = ($text); }

		my $align = GD::Text::Align->new(
			  $gd, valign => 'center', halign => 'center', color => $black);
		if ((!$ayah) || ($ayah == 0)){
			$align->set_font("./data/fonts/QCF_BSML.TTF", $font_size - 1);
		}
		else {
			$align->set_font("./data/fonts/QCF_P$page_str.TTF", $font_size - 1);
		}
		$align->set_text($text);

		my $render_x = -1;
		my $previous_w = -1;
		my $coord_x = $width / 2;
		my $tcoord_y = $i * ($font_size + $line_spacing) + $line_spacing;
		my $line_width = $self->_get_line_width($text, $page_str, $font_size-1);

		my @vals = ();
		my @wstore = ();

		my $max_y = -1;
		my $min_y = -1;
		foreach my $word (@words){
			my $color = $black;
			if (($ayah) && ($ayah > 0)){
				$word = $word . ';';
				if ($self->_is_mention_of_Allah($page, $word)){
					$color = $red;
				}
			}
			$align = GD::Text::Align->new(
				$gd, valign => 'center', halign => 'center', color => $color);
			if ((!$ayah) || ($ayah == 0)){
				$align->set_font("./data/fonts/QCF_BSML.TTF", $font_size - 1);
			}
			else {
				$align->set_font("./data/fonts/QCF_P$page_str.TTF", $font_size - 1);
			}
			$align->set_text($word);

			my @word_box = $align->bounding_box(0, $tcoord_y, 0);
			my $word_width = $word_box[4] - $word_box[0];
			if ($min_y == -1){
				$min_y = $word_box[5];
				$max_y = $word_box[1];
			}
			if ($min_y > $word_box[5]){ $min_y = $word_box[5]; }
			if ($max_y < $word_box[1]){ $max_y = $word_box[1]; }

			if ($render_x == -1){
				$coord_x = (($width - $line_width) / 2) + ($word_width/2);
				$render_x = $coord_x;
				$previous_w = $word_box[4];
			}
			else {
				$render_x = $render_x + ($previous_w) + ($word_width/2);
				$previous_w = $word_box[4];
			}

			if ((!$ayah) || ($ayah == 0)){ $render_x = $width / 2; }
			else {
				my $v = ($render_x + $word_box[0]);
				push(@vals, $v);
				push(@wstore, $word);
			}
			$align->draw($render_x, $tcoord_y, 0);
	}

	# this code prints out the sql necessary to have bounding boxes for
	# each word.  probably should move this into its own sqlite table or
	# something and then if someone wants it elsewhere, they can convert
	# sqlite to mysql or what not.
	#
	# y goes between min_y and max_y.
	# x goes between the last value and the current.
	#
	my $last_val = $render_x + $previous_w;
	my $elem = pop(@vals);
	while ($elem){
		my $w = pop(@wstore);
		$w =~ s/&#//g;
		$w =~ s/;//g;
		my $q = "insert into bounds(page, word, minx, maxx, miny, maxy) values(" .
			"$page, $w, $elem, $last_val, $min_y, $max_y);";
		print $q . "\n";

		$last_val = $elem;
		$elem = pop(@vals);
	}

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

sub _is_mention_of_Allah {
	my ($self, $page, $word) = @_;

	$word =~ s/&#//g;
	$word =~ s/;//g;
	# is there a 'like' syntax in sqlite2?
	my $sth = $corpus_dbh->prepare("select qc_code, lemmas from " .
		"corpus_mappings where page = $page");
  $sth->execute;
	while (my ($qc_code, $lemmas) = $sth->fetchrow_array) {
		if (($qc_code eq $word) || ($qc_code =~ /$word\+.*/)){
			if (($lemmas =~ /{ll~ah/) || ($lemmas =~ /rab~/)){
				$sth->finish;
				return 1;
			}
		}
	}
	$sth->finish;
	return 0;
}


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
