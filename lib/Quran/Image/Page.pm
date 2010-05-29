package Quran::Image::Page;

use strict;
use warnings;

use base qw/Quran Quran::Image/;

use constant DEFAULT_FONT_FILE => Quran::FONTS_DIR .'/QCF_BSML.TTF';

sub generate {
	my ($self, %opt) = @_;

	$self->{_page} = $opt{page} || 'all';
	$self->{_path} = $opt{path} || Quran::ROOT_DIR .'/images';
	$self->{_width} = $opt{width} || 800;
	$self->{_height} = $self->{_width} * Quran::Image::PHI;
	$self->{_font_file} = DEFAULT_FONT_FILE;
	$self->{_font_size} = $self->{_width} / 20;
	$self->{_gd_text} = GD::Text->new(
		font   => $self->{_font_file},
		ptsize => $self->{_font_size}
	) or die GD::Text::error();

	if ($self->{_page} eq 'all') {
		for my $page (reverse 1..604) {
			my $image = $self->_create_image($page);
			$self->image->write($self->{_path}, $page, $image);
		}
	}
	else {
		my $image = $self->_create_image($self->{_page});
		$self->image->write($self->{_path}, $self->{_page}, $image);
	}

	return;
}

sub _create_image {
	my ($self, $page_number) = @_;

	print "Page: $page_number\n";

	# x needs to be scoped and init'd at 0
	# font size needs to be determined algorithmically

	$self->{_coord_x} = 0;
	$self->{_coord_y} = 0;

	my $page_lines = $self->db->_get_page_lines($page_number);
	my $image = ($self->{_gd_image} = GD::Image->new($self->{_width}, $self->{_height}));
	my $colors = ($self->{_colors} = {
		debug => $image->colorAllocate(255,160,64),
		bg    => $image->colorAllocate(255,255,242),
		red   => $image->colorAllocate(255,0,0),
		white => $image->colorAllocate(255,255,255),
		black => $image->colorAllocate(0,0,0)
	});
	my $font_size = $self->{_font_size};

	$image->transparent( $colors->{white} );
	$image->interlaced('true');

	while (my $page_line = shift @{ $page_lines }) {
		my $font_file   = $page_line->{font_file};
		my $line_type   = $page_line->{line_type};
		my $line_text   = $page_line->{line_text};
		my $line_number = $page_line->{line_number};
		my $line_box    = $self->_get_box($font_file, $font_size, $line_text);

		#my $before = $self->{_coord_y};
		$self->{_coord_y} -= $line_box->{y_min} if $self->{_coord_y} == 0 && $line_box->{y_min} < 0;
		#my $after = $self->{_coord_y};
		#print "before $before, after $after\n";
=cut
		$self->{_gd_text}->set(
			font   => $font_file,
			ptsize => $font_size
		) or die GD::Text::error();
		$self->{_gd_text}->set_text($line_text);

		my ($line_box->{char_up}, $line_char_down, $line_space, $line_width) = $self->{_gd_text}->get('char_up', 'char_down', 'space', 'width');

		my @line_bbox = GD::Image->stringFT($colors->{black}, $font_file, $font_size, 0, 0, $self->{_coord_y}, $line_text);

		my $line_x_min = List::Util::min($line_bbox[0], $line_bbox[6]);
		my $line_x_max = List::Util::max($line_bbox[4], $line_bbox[2]);

		if ($line_width >= $self->{_width}) {
			print "NOTICE: line_width $line_width, line_space $line_space, line_x_min $line_x_min, line_x_max $line_x_max, line_char_down $line_char_down, line_char_up $line_box->{char_up}\n";
		}

		my $line_box->{coord_x} = ($self->{_width} - $line_width) / 2;

		# adjust line_coord_y coordinate is in negative space
		if ($line_bbox[7] < 0 || $line_bbox[5] < 0) {
			$self->{_coord_y} += -1 * List::Util::min($line_bbox[7], $line_bbox[5]) - 2 * $line_char_down;
		}
=cut
		# adjust line_coord_y coordinate is in negative space

=cut
		if ($line_box->{y_min} < 0) {
			$self->{_coord_y} -= $line_box->{y_min};
			$self->{_coord_y} -= $line_box->{char_down};
		}
=cut
		# create the string of glyph codes for the line, e.g. "&#64432;&#64365"
		my @glyph_codes = split /;/, $line_text;
		$_ .= ';' for @glyph_codes;
=cut
		# word width needs to be defined here for proper scoping
		my ($word_coord_x, $word_width) = (undef, undef);
		my ($title_coord_x, $title_width, $title_down) = (undef, undef, undef, undef, undef);
=cut

		my ($word_coord_x, $word_width) = (undef, undef);

		for (my $position = 1; $position <= scalar @glyph_codes; $position++) {
			my $glyph_code = $glyph_codes[$position - 1];


			if ($line_type eq 'sura' && $position == 1) {
				my $header_box = $self->_draw_header_box();
				$line_box = $self->_get_max_box($header_box, $line_box);
			}

			my $font_size = $self->{_font_size};

			if ($line_type eq 'sura' or $line_type eq 'bismillah') {
				#$font_size *= 1.1;
			}

			my $word_box = $self->_get_box($font_file, $font_size, $glyph_code);
			if (!defined $word_coord_x) {
				#print "coord_x ". $line_box->{coord_x} ." width ". $line_box->{width} ." size ". $self->{_width} ."\n";
				$word_coord_x = $line_box->{coord_x};# - $line_box->{space};# - $word_box->{space};
			}
			else {
				$word_coord_x += $word_width;
			}

			$word_width = $word_box->{x_max};

			if ($line_type eq 'ayah') {
				my $box = $self->_draw_word($position, $glyph_code, $font_size, $font_file, $word_coord_x, $page_number, $line_number);
				$line_box = $self->_get_max_box($box, $line_box);
			}
=cut
			if ($line_type eq 'sura') {
				my $font_size = $self->{_font_size} * 1.1;
				my $sura_box = $self->_draw_word($position, $glyph_code, $font_size, $font_file, $word_coord_x);
				$line_box = $self->_get_max_box($sura_box, $line_box);
			}
			elsif ($line_type eq 'bismillah') {
				my $font_size = $self->{_font_size} * 1.1;
				my $bismillah_box = $self->_draw_word($position, $glyph_code, $font_size, $font_file, $word_coord_x);
				$line_box = $self->_get_max_box($bismillah_box, $line_box);
			}
			$self->{_gd_text}->set_text($glyph_code);

			my ($word_char_up, $word_char_down, $word_space) = $self->{_gd_text}->get('char_up', 'char_down', 'space');

			if (!defined $word_coord_x) {
				$word_coord_x = $line_box->{coord_x} - 2 * $word_space;
			}
			else {
				$word_coord_x += $word_width;
			}

			my @word_bbox = GD::Image->stringFT($colors->{black}, $font_file, $font_size, 0, 0, $self->{_coord_y}, $glyph_code);

			my $word_x_min = List::Util::min($word_bbox[0], $word_bbox[6]);
			my $word_x_max = List::Util::max($word_bbox[4], $word_bbox[2]);

			$word_width = $word_x_max;

			elsif ($line_type eq 'ayah') {
				$self->_draw_ayah_line;
			}
=cut
		}

		$self->{_coord_y} -= $line_box->{char_down} + 1.5; # constant 1.5 hack or necessary?
		$self->{_coord_y} += 2 * $line_box->{char_up}; # adjustment for all other pages
=cut
		$self->{_coord_y} += $line_box->{char_down};
		$self->{_coord_y} += $line_box->{char_up}; # adjustment for all other pages
		$self->{_coord_y} -= $line_box->{y_min} if $line_box->{y_min} < 0;
		# adjust $self->{_coord_y} for next iteration
		if ($page_number == 1 || $page_number == 2) {
			$self->{_coord_y} += Quran::Image::PHI * $line_box->{char_up}; # adjustment for surat al fatiha and surat al baqara
		}
		else {
			$self->{_coord_y} += 2 * $line_box->{char_up}; # adjustment for all other pages
		}
=cut
	}

	return $image;
}

sub _get_box {
	my ($self, $font_file, $font_size, $text_string) = @_;

	$self->{_gd_text}->set(
		font   => $font_file,
		ptsize => $font_size
	);
	$self->{_gd_text}->set_text($text_string);

	my ($space, $char_down, $char_up) = $self->{_gd_text}->get('space', 'char_down', 'char_up');

	# @bbox[0,1]  Lower left corner (x,y)
	# @bbox[2,3]  Lower right corner (x,y)
	# @bbox[4,5]  Upper right corner (x,y)
	# @bbox[6,7]  Upper left corner (x,y)

	my @bbox = GD::Image->stringFT($self->{_colors}->{black}, $font_file, $font_size, 0, 0, 0, $text_string);
	my $x_min = List::Util::min($bbox[0], $bbox[6]);
	my $x_max = List::Util::max($bbox[4], $bbox[2]);
	my $y_min = List::Util::min($bbox[7], $bbox[5]);
	my $y_max = List::Util::max($bbox[1], $bbox[3]);
	my $width = $x_max - $x_min - $space;

	#print "max $x_max, min $x_min, space $space, width $width\n";
	#print "down $char_down, up $char_up\n";

	my $coord_x = ($self->{_width} - $width) / 2;
	my $coord_y = $self->{_coord_y};

	$coord_y -= $y_min if $y_min < 0;
	$coord_y -= $char_down;

	return {
		coord_x   => $coord_x,
		coord_y   => $coord_y,
		x_min     => $x_min,
		x_max     => $x_max,
		y_min     => $y_min,
		y_max     => $y_max,
		space     => $space,
		char_down => $char_down,
		char_up   => $char_up,
		width     => $width
	};
	#return ($coord_x, $coord_y, $x_min, $x_max, $y_min, $y_max);
}

sub _get_max_box {
	my $self = shift;
	my ($box_a, $box_b) = @_;
	my $box_c;
	my @lt = qw/coord_x coord_y x_min y_min char_down/;
	my @gt = qw/x_max y_max space char_up width/;
	for (@lt) {
		$box_c->{$_} = ($box_a->{$_} < $box_b->{$_})? $box_a->{$_} : $box_b->{$_};
	}
	for (@gt) {
		$box_c->{$_} = ($box_a->{$_} > $box_b->{$_})? $box_a->{$_} : $box_b->{$_};
	}
	return $box_c;
}

sub _draw_header_box {
	my $self = shift;
	my $font_file = DEFAULT_FONT_FILE;
	my $font_size = $self->{_font_size};# * (Quran::Image::phi ** 3 + Quran::Image::PHI);
	my $glyph_code = $self->db->get_ornament_glyph_code('header-box');
	my $header_box = $self->_get_box($font_file, $font_size, $glyph_code);

	$self->{_sura_number} = 114 if not defined $self->{_sura_number};

	print "\tSura ". $self->{_sura_number}-- ."\n";

	$self->{_gd_image}->stringFT($self->{_colors}->{black}, $font_file, $font_size, 0, $header_box->{coord_x}, $self->{_coord_y}, $glyph_code);

	return $header_box;
}

sub _draw_word {
	my $self = shift;
	my ($position, $glyph_code, $font_size, $font_file, $word_coord_x, $page_number, $line_number) = @_;

	my $box = $self->_get_box($font_file, $font_size, $glyph_code);

	#my $lemma = $self->db->_get_word_lemma($glyph_code, $page_number);

	#print "position $position, coord_y ". $box->{coord_y} ." lemma $lemma, page $page_number, line $line_number\n";

	$self->{_gd_image}->stringFT($self->{_colors}->{black}, $font_file, $font_size, 0, $word_coord_x, $self->{_coord_y}, $glyph_code);

	return $box;
}

sub _draw_bismillah_word {
	my $self = shift;
	my ($position, $glyph_code, $font_file, $word_coord_x) = @_;
=cut
	if ($position == 1) {
		my $glyph_type = $self->db->_get_glyph_type($glyph_code, 0);
		if ($glyph_type eq 'bismillah-default') {
			$line_coord_y -= $line_char_down;
		}
	}

	my $coord_y = $line_coord_y;
	if ($line_number > 2) {
		$coord_y += 2 * $line_char_down;
	}
	else {
		$coord_y -= 1 * $line_char_down;
	}
=cut
	my $font_size = $self->{_font_size} * 1.1;# * (Quran::Image::phi ** 5 + 1);
	my $box = $self->_get_box($font_file, $font_size, $glyph_code);

	$self->{_gd_image}->stringFT($self->{_colors}->{black}, $font_file, $font_size, 0, $word_coord_x, $box->{coord_y}, $glyph_code);
	#$self->{_gd_image}->stringFT($colors->{black}, $font_file, $font_size, 0, $word_coord_x, $coord_y, $glyph_code);
=cut
	if ($position == 3 && $line_number <= 2) {
		$line_coord_y -= 3 * $line_char_down;
	}
=cut
	return $box;
}

=cut

sub _draw_ayah_line {
				# assign color to the word
				my $word_color = $self->_is_mention_of_Allah($glyph_code, $page_number, $line_type)? $colors->{red} : $colors->{black};
				# render the individual word
				$self->{_gd_image}->stringFT($word_color, $font_file, $font_size, 0, $word_coord_x, $line_coord_y + 2 * $line_char_down, $glyph_code);
}

=cut

1;
__END__
