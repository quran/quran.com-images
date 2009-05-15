#!/usr/bin/env perl
# bismillah in the name of allah most gracious, most merciful
# author nour sharabash
# original php script by ahmed el-helw
# contributions from bassem shama
use strict;
use warnings;

use DBI;
my $dbh = DBI->connect("dbi:SQLite2:dbname=./data/sura_ayah_page_text.sqlite2.db","","",
	{ RaiseError => 1, AutoCommit => 0 });

use GD;
use GD::Text;
use GD::Text::Align;

use Getopt::Long;
use Pod::Usage;

my ($sura, $ayah, $batch, $width, $em, $help) = (undef, undef, undef, 640, 1.0, 0);

my $self = \&main;
bless $self;

GetOptions(
	'sura=i' => \$sura,
	'ayah=i' => \$ayah,
	'batch' => \$batch,
	'width:i' => \$width,
	'em:f' => \$em,
	'help|?' => \$help,
) or pod2usage(1);
pod2usage(1) if $help;

$em = sprintf('%.1f',$em);

die "Minimal parameters are both --sura and --ayah for a single verse, or \
use --batch to generate images for the entire Qur'an" unless ($batch or ($sura and $ayah));

if ($batch) {
	$self->generate_batch;
}
else {
	$self->generate_image($sura, $ayah);
}

sub generate_batch {
	my ($self) = @_;

	my $sth = $dbh->prepare(
		"select sura, ayah from sura_ayah_page_text order by sura asc, ayah asc");

	$sth->execute();
	while (my $row = $sth->fetchrow_hashref) {
		$self->generate_image($row->{sura}, $row->{ayah});
	}
	$sth->finish();
}

sub generate_image {
	my ($self, $sura, $ayah) = @_;

	my $phi = (((sqrt(5)+1)/2) - 1);

	my @row = $dbh->selectrow_array(
		"select page, text from sura_ayah_page_text where sura = $sura and ayah = $ayah");

	my $page = $row[0];
	my $text = $self->_reverse_text($row[1]);
	my $font_size = 24;
	$font_size = $font_size * $em;
	my $padding = $font_size * $phi + ($font_size * $phi * $phi * $phi);
	my $inner_width = $width - (2*$padding);

  my $gd_text = GD::Text->new() or die GD::Text::error();
	$gd_text->set_font("./data/fonts/QCF_P$page.TTF", $font_size) or die $gd_text->error;
  $gd_text->set_text($text);
  my $_width = $gd_text->get('width');
	my $_wrap_text = sub {
		my $text = shift;
		my @line = split /\n/, $text;
		my %longest = (
			width => 0,
			line  => 0
		);
		for (my $i = 0; $i < @line; $i++) {
			my $line_text = $line[$i];
			$gd_text->set_text($line_text);
			my $width = $gd_text->get('width');
			do {
				$longest{width} = $width;
				$longest{line}  = $i;
			} if ($width > $longest{width});
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
	while ($_width > $inner_width) {
		$text = $_wrap_text->($text);
		$gd_text->set_text($text);
		$_width = $gd_text->get('width');
	}
  my $_height = $gd_text->get('height');
	my @line = split /\n/, $text;
	my $lines = scalar @line;
	my $sub_phi = 1 + ($phi * $phi * $phi);
	my $line_spacing = $font_size * $sub_phi;
	my $height = $lines * $_height + ($lines - 1) * $line_spacing;

	my $gd = GD::Image->new(($inner_width + (2*$padding)), ($height + (2*$padding)));
	my $white = $gd->colorAllocate(255,255,255);
	my $black = $gd->colorAllocate(0,0,0);
	$gd->transparent($white);
	$gd->interlaced('true');

	my $_draw_line = sub {
		my ($i, $text) = @_;
		my $align = GD::Text::Align->new($gd,
			valign => 'top',
			halign => 'right',
			color  => $black,
		);
		$align->set_font("./data/fonts/QCF_P$page.TTF", $font_size);
		$align->set_text($text);
		$align->draw(($inner_width + $padding), ($padding * $phi) + ($i * ($font_size + $line_spacing)), 0);
	};


	for (my $i = 0; $i < @line; $i++) {
		my $text = $line[$i];
		$_draw_line->($i, $text);
	}

	my $path = './output/width_'. $width .'/em_'. $em .'/';
	my $file = $sura ."_". $ayah .".png";
	eval { `mkdir -p $path` };
	open OUTPUT, ">". $path . $file;
	binmode OUTPUT;
	print OUTPUT $gd->png;

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

auto.pl - Generate Qur'an Images for Ayahs

=head1 SYNOPSIS

auto.pl --sura n --ayah n [options]


=head1 OPTIONS

	-s    --sura     sura number to process
	-a    --ayah     ayah number to process
	-b    --batch    process the entire Qur'an in one shot
	-w    --width    width of image in pixels
	-e    --em       scale font size by given factor
	-h    --help     print this help message and exit

e.g. './auto.pl -s 2 -a 255 --width=480 --em=0.9' would output Ayah
     Al-Kursi (2:255) as a png image in the sub 'output' directory.

i.e. './output/width_480/em_0.9/2_255.png' the image for 480 pixels
     at 90% font size.

=cut
# vim: ts=2 sw=2 noexpandtab
