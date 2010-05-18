# بسم الله الرحمن الرحيم

package Quran;

use strict;
use warnings;

use FindBin;
use AutoLoader qw/AUTOLOAD/;
use Carp;

our $VERSION = '0.01';

use constant ROOT_DIR => "$FindBin::Bin/..";

sub new;
sub super;

sub db {
	my $self = shift;
	if (!defined $self->{_db}) {
		use Quran::DB;
		$self->{_db} = Quran::DB->new(
			database => 'nextgen',
			username => 'root',
			password => 'crackme'
		); # TODO: load database settings from config file
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
