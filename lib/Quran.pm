# بسم الله الرحمن الرحيم

package Quran;

use utf8;
use strict;
use warnings;

use FindBin;
use AutoLoader qw/AUTOLOAD/;
use Carp;

our $VERSION = '0.01';

use constant ROOT_DIR => "$FindBin::Bin/..";
use constant FONT_DIR => Quran::ROOT_DIR .'/res/fonts';

sub new;
sub super;

sub db {
	my $self = shift;
	if (!defined $self->{_db}) {
		use Quran::DB;
		use YAML;
		open CONFIG, '<', Quran::ROOT_DIR .'/config/database.yaml'
			or die "can't open config file $!";
		my $yaml = do { local $/; <CONFIG> };
		close CONFIG;
		my $config = Load($yaml);
		$self->{_db} = Quran::DB->new($config);
	}
	return $self->{_db};
}

sub image {
	my ($self) = @_;
	if (!defined $self->{_image}) {
		use Quran::Image;
		$self->{_image} = new Quran::Image;
	}
	return $self->{_image};
}


1;
__END__

sub new {
	my $class = shift;
	bless {
		_class => $class
	}, $class;
}

sub super {
	my $self = shift;
	if (!defined $self->{_super}) {
		($self->{_super} = $self->{_class}) =~ s/::[^:]+$//;
		$self->{_super} = new $self->{_super};
	}
	return $self->{_super};
}


=head1 NAME

Quran

=head1 SYNOPSIS

Perl library used for misc. functions of Quran.com.

=head1 DESCRIPTION

	Perl library used for misc. functions of Quran.com, such as
	image generation.

=head1 AUTHORS

	Nour Sharabash E<lt>nour.sharabash@gmail.com<gt>
	Ahmed El-Helw E<lt>ahmedre@gmail.com<gt>

=head1 COPYRIGHT AND LICENSE

	Copyright (C) 2010 by Quran.com

	This library is free software. You can redistribute it and/or
	modify it under the same terms as Perl itself.


=cut
