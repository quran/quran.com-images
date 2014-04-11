package QuranImage::Generator::Ayah;
use Moose; with 'Nour::Script'; with 'QuranImage::Generator';

sub generate {
    my $self = shift;
    my $opts = $self->option;
    my $conf = $self->config;
}

# ABSTRACT: generate an ayah or set of ayahs with madani mushaf font
1;
__END__
