package QuranImage::Generator;
use Moose::Role;
use File::Path qw/make_path/;

sub png {
    my ( $self, %opts ) = @_;

    return print $opts{image}->png( 9 ) unless $opts{path} and $opts{file}; # stdout
    File::Path::make_path( $opts{path}, { # to file
        verbose => 1
        ,  mode => 0711
    } );
    open PNG, ">$opts{path}/$opts{file}";
    binmode PNG;
    print PNG $opts{image}->png( 9 );
    return;
}

# ABSTRACT: shared methods for QuranImage::Generator::Page and QuranImage::Generator::Ayah
1;
