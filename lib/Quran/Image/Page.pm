package Quran::Image::Page;

use strict;
use warnings;

use base qw/Quran Quran::Image/;

sub generate {
	my ($self, %opt) = @_;

	my $page = ($self->{_page} = $opt{page}) || 'all';
	my $path = ($self->{_path} = $opt{path}) || Quran::ROOT_DIR .'/images';
	my $width = ($self->{_width} = $opt{width}) || 800;
	my $height = ($self->{_height} = $width * Quran::Image::PHI);
	my $font_size = ($self->{_font_size} = $width / 20);

	if ($page eq 'all') {
		for my $page (1..604) {
			my $image = $self->_create_image($page);
			$self->_write_image($path, $page, $image);
		}
	}
	else {
		my $image = $self->_create_image($page);
		$self->_write_image($path, $page, $image);
	}

	return;
}

sub _create_image {
	my ($self, $page_number) = @_;
	my $page_lines = $self->db->_get_page_lines($page_number);
	my $image = ($self->{_image} = GD::Image->new($self->{_width},
		$self->{_height}));
	my $colors = ($self->{_color} = {
		bg    => $image->colorAllocate(255,255,242),
		red   => $image->colorAllocate(255,0,0),
		white => $image->colorAllocate(255,255,255),
		black => $image->colorAllocate(0,0,0)
	});
	my $line_coord_y = 0;
	my $font_size = $self->{_font_size};

	$image->transparent( $colors->{white} );
	$image->interlaced('true');

	while (my $page_line = shift @{ $page_lines }) {
		my $font_file = $page_line->{font_file};
		my $line_type = $page_line->{line_type};
		my $line_text = $page_line->{line_text};
		my $gd_text = GD::Text->new(
			font => $font_file,
			ptsize => $font_size
		) or die GD::Text::error();
	
		$gd_text->set_text($line_text);

		my ($line_up, $line_down, $line_space) = $gd_text->get('char_up', 'char_down',
			'space');

		my @line_bb = GD::Image->stringFT($colors->{black}, $font_file, $font_size,
			0, 0, $line_coord_y, $line_text);
		my $line_width = List::Util::max($line_bb[4], $line_bb[2]);

		# set x to the pixel coordinate of the beginning of the left margin
		my $line_coord_x = ($self->{_width} - $line_width) / 2;

		# adjust line_coord_y coordinate is in negative space
		if ($line_bb[7] < 0 || $line_bb[5] < 0) {
			$line_coord_y += -1 * List::Util::max($line_bb[7], $line_bb[5]);
		}

		# create the string of char codes for the line, e.g. "&#64432;&#64365"
		my @char_codes = split /;/, $line_text;
		$_ .= ';' for @char_codes;

		my ($word_coord_x, $word_width, $char_position) = (undef, undef, 1);

		for my $char_code (@char_codes) {

			if (!defined $word_coord_x) {
				$word_coord_x = $line_coord_x;
			}
			else {
				$word_coord_x += $word_width;
			}

			my @word_bb = GD::Image->stringFT($colors->{black}, $font_file, $font_size,
				0, 0, $line_coord_y, $char_code);

			$gd_text->set_text($char_code);
			my $word_space = $gd_text->get('space');

			# here we make use of the word's bounding box
			$word_width = List::Util::max($word_bb[4], $word_bb[2]) - $word_space/2;

			# draw a header box glyph if this line is supposed to be a sura header
			if ($line_type eq 'sura-header' and $char_position == 1) {
				my ($font_file, $char_code) = $self->db->_get_ornament('header-box');
				my $font_size = $font_size * Quran::Image::PHi;

				$gd_text->set( ptsize => $font_size );
				$gd_text->set_text($char_code);

				my @header_bb = GD::Image->stringFT($colors->{black}, $font_file,
					$font_size, 0, 0, $line_coord_y, $char_code);
				my $header_width = List::Util::max($header_bb[4], $header_bb[2]);
				my $header_coord_x = ($self->{_width} - $header_width) / 2;
				my $header_coord_y = $line_coord_y;

				# adjust line_coord_y coordinate is in negative space
				if ($header_bb[7] < 0 || $header_bb[5] < 0) {
					$header_coord_y += -1 * List::Util::max($header_bb[7], $header_bb[5])
						- 2 * $line_down;
					$line_coord_y += -1 * List::Util::max($header_bb[7], $header_bb[5])
						- $line_down;
				}

				$self->{_image}->stringFT($colors->{black}, $font_file, $font_size, 0,
					$header_coord_x, $header_coord_y, $char_code);

				$self->{_sura_number} = 1 if not defined $self->{_sura_number};

				print "Sura ". $self->{_sura_number}++ ."...\n";
			}
			elsif ($line_type eq 'bismillah' and $char_position == 1) {
				my $char_type = $self->db->_get_char_type($char_code, 0);
				if ($char_type eq 'bismillah-default') {
					print "adjust me\n";
					$line_coord_y += 8 * $line_down;
				}
			}

			# assign color to the word
			my $word_color = $self->_is_mention_of_Allah($char_code, $page_number,
				$line_type)? $colors->{red} : $colors->{black};

			# render the individual word
			@word_bb = $self->{_image}->stringFT($word_color, $font_file, $font_size,
				0, $word_coord_x, $line_coord_y, $char_code);

			$char_position++;

			if ($line_type eq 'sura-header' and $char_position == 3) {
				$line_coord_y -= 5 * $line_down;
			}
		}

		if ($page_number == 1 || $page_number == 2) {
			$line_coord_y += Quran::Image::PHI * $line_up;
		}
		else {
			$line_coord_y += 2 * $line_up;
		}
	}

	print "...page $page_number\n";

	return $image;
}

1;
__END__
