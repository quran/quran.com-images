package Quran::Image;

use strict;
use warnings;

use base qw/Quran/;

use GD;
use GD::Text;
use GD::Text::Align;
use List::Util qw/min max/;
use File::Path qw/make_path/;

use constant PHI => ((sqrt 5) + 1) / 2;
use constant phi => (((sqrt 5) + 1) / 2) - 1;

use constant FONTS_DIR => Quran::ROOT_DIR .'/res/fonts';

sub ayah {
	my $self = shift;
	if (!defined $self->{_ayah}) {
		use Quran::Image::Ayah;
		$self->{_ayah} = new Quran::Image::Ayah;
	}
	return $self->{_ayah};
}

sub page {
	my $self = shift;
	if (!defined $self->{_page}) {
		use Quran::Image::Page;
		$self->{_page} = new Quran::Image::Page;
	}
	return $self->{_page};
}

sub _write_image {
	my ($self, $path, $page, $image) = @_;

	File::Path::make_path($path, {
		verbose => 1,
		mode => 0711
	});

	open PNG, ">$path/$page.png";
	binmode PNG;

	print PNG $image->png(9);

	return;
}

sub _is_mention_of_Allah {
	my ($self, $char_code, $page_number) = @_;

	my $lemma = $self->db->_get_word_lemma($char_code, $page_number);

	return ($lemma eq '{ll~ah' or $lemma eq 'rab~')? 1 : 0;
}

1;
__END__
