package Quran::DB;

use strict;
use warnings;

use base qw/Quran/;

use DBI;

sub new {
	my $class = shift;
	my %opt = @_;

	my $database = $opt{database} or die "database name needed";
	my $username = $opt{username} or die "database username needed";
	my $password = $opt{password} or die "database password needed";

	my $dbh = DBI->connect("dbi:mysql:$database", $username, $password);

	bless {
		_class => $class,
		_dbh   => $dbh
	}, $class;
}

sub _get_page_lines {
	my ($self, $page_number) = @_;

	if (!defined $self->{_select_page_chars}) {
		$self->{_select_page_chars} = $self->{_dbh}->prepare_cached(
			"SELECT cp.line_number, cp.line_type, ".
			"cp.char_position, c.font_file, c.char_code FROM char_page cp, ".
			"`char` c WHERE c.char_id = cp.char_id AND cp.page_number = ? ".
			"ORDER BY cp.page_number ASC, cp.line_number ASC, ".
			"cp.char_position ASC");
	}

	$self->{_select_page_chars}->execute($page_number);

	my $page_lines = [];

	while (my ($line_number, $line_type, $char_position, $font_file,
		$char_code) = $self->{_select_page_chars}->fetchrow_array) {
		if (!defined $page_lines->[$line_number - 1]) {
			$page_lines->[$line_number - 1] = {
				page_number => $page_number,
				line_number => $line_number,
				line_type   => $line_type,
				font_file   => Quran::FONTS_DIR .'/'. $font_file,
				char_codes  => [$char_code]
			};
		}
		else {
			push @{ $page_lines->[$line_number - 1]->{char_codes} }, 
				$char_code;
		}
	}

	for my $page_line (@{ $page_lines }) {
		$page_line->{line_text} = '&#'. 
			join(';&#', reverse sort @{ $page_line->{char_codes} }) .';';
	}

	$self->{_select_page_chars}->finish;

	return $page_lines;
}

sub _get_ornament {
	my ($self, $name) = @_;

	my $sth;
	if (!defined $self->{_sth_ornament}) {
		$sth = ($self->{_sth_ornament} = $self->{_dbh}->prepare_cached(
		"SELECT c.font_file, c.char_code FROM `char` c, char_type ct, ".
		"char_type ctp WHERE c.char_type_id = ct.char_type_id AND ".
		"ct.parent_id = ctp.char_type_id AND ctp.name = 'ornament' AND ".
		"ct.name = ?"));
	}
	else {
		$sth = $self->{_sth_ornament};
	}

	$sth->execute($name);

	my ($font_file, $char_code) = $sth->fetchrow_array;

	$char_code = '&#'. $char_code .';';
	$font_file = Quran::FONTS_DIR .'/'. $font_file;

	$sth->finish;

	return ($font_file, $char_code);
}

sub _get_char_type {
	my ($self, $char_code, $page_number) = @_;

	$char_code =~ s/[^\d]*//g;

	my $sth;
	if (!defined $self->{_sth_char_type}) {
		$sth = ($self->{_sth_char_type} = $self->{_dbh}->prepare_cached(
		"SELECT ct.name FROM char_type ct, `char` c WHERE c.char_type_id = ".
		"ct.char_type_id AND c.char_code = ? AND c.page_number = ?"));
	}
	else {
		$sth = $self->{_sth_char_type};
	}

	$sth->execute($char_code, $page_number);

	my ($char_type) = $sth->fetchrow_array;

	$sth->finish;

	return $char_type? $char_type : '';
}

sub _get_word_lemma {
	my ($self, $char_code, $page_number) = @_;
	$char_code =~ s/[^\d]//g;

	my $sth;

	if (!defined $self->{_sth_word_lemma}) {
		$sth = ($self->{_sth_word_lemma} = $self->{_dbh}->prepare_cached(
		"SELECT wl.value FROM word_lemma wl, word w, `char` c WHERE ".
		"w.word_lemma_id = wl.word_lemma_id AND w.char_id = c.char_id AND ".
		"c.char_code = ? AND w.page_number = ?"));
	}
	else {
		$sth = $self->{_sth_word_lemma};
	}

	$sth->execute($char_code, $page_number);

	my ($word_lemma) = $sth->fetchrow_array;

	$sth->finish;

	return $word_lemma? $word_lemma : '';
}

1;
