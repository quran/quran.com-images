package Quran::Image::Page;

use strict;
use warnings;

use List::Util qw/min max/;

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
	my $color = ($self->{_color} = {
		white => $image->colorAllocateAlpha(255,255,255,127),
		black => $image->colorAllocate(0,0,0),
		red   => $image->colorAllocate(255,0,0)
	});
	$image->transparent( $color->{white} );
	$image->interlaced('false');

	my $coord_y = 0;

	while (my $page_line = shift @{ $page_lines }) {
		my $font_file = Quran::Image::FONTS_DIR .'/'.
			$page_line->{font_file};
		my $gd_text = GD::Text->new(
			font => $font_file,
			ptsize => $self->{_font_size}
		) or die GD::Text::error();
	
		$gd_text->set_text($page_line->{line_text});
		my ($w, $h, $s, $u, $d) = $gd_text->get('width', 'height', 'space',
			'char_up', 'char_down');

		my @bb = GD::Image->stringFT($self->{_color}->{black},
			$font_file, $self->{_font_size}, 0, ($self->{_width} - $w)/2,
			$coord_y, $page_line->{line_text});

		if ($bb[7] < 0 || $bb[5] < 0) {
			$coord_y += -1 * min($bb[7], $bb[5]);
		}

		@bb = $self->{_image}->stringFT($self->{_color}->{black},
			$font_file, $self->{_font_size}, 0, ($self->{_width} - $w)/2,
			$coord_y, $page_line->{line_text});

		if ($page_number == 1 || $page_number == 2) {
			$coord_y += Quran::Image::PHI * $u;
		}
		else {
			$coord_y += 2 * $u;
		}
	}

	return $image;
}

1;
__END__
