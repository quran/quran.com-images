package Quran::Image::Page;

use strict;
use warnings;

use base qw/Quran Quran::Image/;

use constant DEFAULT_FONT_FILE => Quran::FONTS_DIR .'/QCF_BSML.TTF';

sub generate {
	my ($self, %opts) = @_;

	$self->{_page} = $opts{page} || 'all';
	$self->{_path} = $opts{path} || Quran::ROOT_DIR .'/images';
	$self->{_width} = $opts{width} || 800;
	$self->{_height} = $self->{_width} * Quran::Image::PHI;
	$self->{_font_file} = DEFAULT_FONT_FILE;
	$self->{_font_size} = $self->{_width} / 21; # TODO: determine font size algorithmically
	$self->{_gd_text} = GD::Text->new(
		font   => $self->{_font_file},
		ptsize => $self->{_font_size}
	) or die GD::Text::error();

	if ($self->{_page} eq 'all') {
		for my $page (reverse 1..604) {
			my $image = $self->_make_page($page);
			$self->image->write($self->{_path}, $page, $image);
		}
	}
	else {
		my $image = $self->_make_page($self->{_page});
		$self->image->write($self->{_path}, $self->{_page}, $image);
	}

	return;
}

sub _make_page {
	my ($self, $page_number) = @_;

	print "Page: $page_number\n";

	$self->{_coord_y} = 0;

	my $page_lines = $self->db->_get_page_lines($page_number);
	my $image = ($self->{_gd_image} = GD::Image->new($self->{_width}, $self->{_height}));
	my $colors = ($self->{_colors} = {
		bg    => $image->colorAllocate(248,241,225),
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
		my $line_box    = $self->_box(
				type   => 'line',
				font   => $font_file,
				ptsize => $font_size,
				text   => $line_text
			);

		$self->{_coord_y} -= $line_box->{y_min} if $self->{_coord_y} == 0 && $line_box->{y_min} < 0;

		my @glyph_codes = split /;/, $line_text;
		$_ .= ';' for @glyph_codes;

		$self->{_previous_w} = 0;
		$self->{_coord_x} = 0;

		for (my $position = 1; $position <= scalar @glyph_codes; $position++) {
			my $glyph_code = $glyph_codes[$position - 1];

			if ($line_type eq 'sura' && $position == 1) {
				my $header_box = $self->_draw_header();
			}

			my $font_size = $self->{_font_size};

			my $word_box = $self->_box(
				type   => $line_type,
				font   => $font_file,
				ptsize => $font_size,
				text   => $glyph_code
			);

			if (!$self->{_coord_x}) {
				$self->{_coord_x} = $line_box->{coord_x} - 4 * $line_box->{space};
			}
			else {
				$self->{_coord_x} += $self->{_previous_w};
			}

			$self->{_coord_x} += $word_box->{space} if $line_type eq 'bismillah';

			if ($line_type eq 'ayah') {
				$self->{_previous_w} = $word_box->{x_max};
			}
			else {
				print "$line_number: ".
					"\twidth ". $word_box->{width} .", ".
					"\tx_min ". $word_box->{x_min} .", ".
					"\tx_max ". $word_box->{x_max} .", ".
					"\tspace ". $word_box->{space} .",\n";
				$self->{_previous_w} = $word_box->{width};
			}

			my $box = $self->_draw_word(
				type     => $line_type,
				text     => $glyph_code,
				font     => $font_file,
				ptsize   => $font_size,
				position => $position,
				page     => $page_number
			);
			$line_box = $self->_max_box($box, $line_box);
		}

		$self->{_coord_y} -= $line_box->{char_down};

		if ($page_number == 1 || $page_number == 2) {
			$self->{_coord_y} += Quran::Image::PHI * $line_box->{char_up};
		}
		else {
			$self->{_coord_y} += 1.9 * $line_box->{char_up};
		}
	}

	return $image;
}


sub _draw_word {
	my $self = shift;
	my %opts = @_;

	my $box = $self->_box(
		type   => $opts{type},
		text   => $opts{text},
		font   => $opts{font},
		ptsize => $opts{ptsize}
	);

	$self->{_coord_x} -= 2 * $box->{space} if $opts{type} eq 'sura';

	my $color = $self->{_colors}->{black};
	if ($opts{type} eq 'ayah') {
		$color = $self->_is_mention_of_Allah($opts{text}, $opts{page}, $opts{type})? $self->{_colors}->{red} : $self->{_colors}->{black};
	}
	$self->{_gd_image}->stringFT($color, $opts{font}, $opts{ptsize}, 0, $self->{_coord_x}, $self->{_coord_y}, $opts{text});

	return $box;
}


sub _draw_header {
	my $self = shift;
	my $font_file = DEFAULT_FONT_FILE;
	my $font_size = $self->{_font_size} * (Quran::Image::phi ** 3 + Quran::Image::PHI);
	my $glyph_code = $self->db->get_ornament_glyph_code('header-box');
	my $header_box = $self->_box(
		type   => 'header',
		text   => $glyph_code,
		font   => $font_file,
		ptsize => $font_size
	);

	$self->{_sura_number} = 114 if not defined $self->{_sura_number};

	print "\tSura ". $self->{_sura_number}-- ."\n";

	$header_box->{coord_y} += $header_box->{y_min} if $header_box->{y_min} < 0;
	$header_box->{coord_y} -= 2 * $header_box->{char_down};
	$self->{_coord_y} += $header_box->{y_min};
	$self->{_coord_y} += $header_box->{char_up};
	$self->{_coord_y} -= 2 * $header_box->{char_down};

	$self->{_gd_image}->stringFT($self->{_colors}->{black}, $font_file, $font_size, 0, $header_box->{coord_x}, 
		$header_box->{coord_y}, $glyph_code);

	return $header_box;
}


sub _box {
	my $self = shift;
	my %opts = @_;

	$self->{_gd_text}->set(
		font   => $opts{font},
		ptsize => $opts{ptsize}
	);
	$self->{_gd_text}->set_text($opts{text});

	my ($space, $char_down, $char_up) = $self->{_gd_text}->get('space', 'char_down', 'char_up');

	# @bbox[0,1]  Lower left corner (x,y)
	# @bbox[2,3]  Lower right corner (x,y)
	# @bbox[4,5]  Upper right corner (x,y)
	# @bbox[6,7]  Upper left corner (x,y)

	my @bbox = GD::Image->stringFT($self->{_colors}->{black}, $opts{font}, $opts{ptsize}, 0, 0, 0, $opts{text});
	my $x_min = List::Util::min($bbox[0], $bbox[6]);
	my $x_max = List::Util::max($bbox[4], $bbox[2]);
	my $y_min = List::Util::min($bbox[7], $bbox[5]);
	my $y_max = List::Util::max($bbox[1], $bbox[3]);

	my $width = $x_max;

	$width -= $x_min   if $opts{type} eq 'header';
	$width += $space   if $opts{type} eq 'bismillah';

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
}


sub _max_box {
	my $self = shift;
	my ($box_a, $box_b) = @_;
	my $box_c;
	my @lt = qw/x_min y_min char_down coord_x coord_y/;
	my @gt = qw/x_max y_max space char_up width/;
	for (@lt) {
		$box_c->{$_} = ($box_a->{$_} < $box_b->{$_})? $box_a->{$_} : $box_b->{$_};
	}
	for (@gt) {
		$box_c->{$_} = ($box_a->{$_} > $box_b->{$_})? $box_a->{$_} : $box_b->{$_};
	}
	return $box_c;
}

1;
__END__
