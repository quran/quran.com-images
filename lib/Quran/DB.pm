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

sub get_page_lines {
	my ($self, $page) = @_;

	if (!defined $self->{_select_page_glyphs}) {
		$self->{_select_page_glyphs} = $self->{_dbh}->prepare_cached(
			"SELECT gpl.line_number, gpl.line_type, gpl.position, g.font_file, ".
			"g.glyph_code, gt.name FROM glyph_page_line gpl LEFT JOIN glyph g ON ".
			"g.glyph_id = gpl.glyph_id LEFT JOIN glyph_type gt ON g.glyph_type_id = ".
			"gt.glyph_type_id WHERE gpl.page_number = ? ORDER BY gpl.page_number ASC, ".
			"gpl.line_number ASC, gpl.position DESC");
	}

	$self->{_select_page_glyphs}->execute($page);

	my $lines = [];

	while (my ($line_number, $line_type, $glyph_position, $line_font, $glyph_code, $glyph_type) = $self->{_select_page_glyphs}->fetchrow_array) {
		my $glyph_text = '&#'. $glyph_code .';';
		if (!defined $lines->[$line_number - 1]) {
			$lines->[$line_number - 1] = {
				number => $line_number,
				type   => $line_type,
				text   => $glyph_text,
				font   => Quran::FONT_DIR .'/'. $line_font,
				glyphs => [{
					code     => $glyph_code,
					text     => $glyph_text,
					type     => $glyph_type,
					position => $glyph_position
				}],
			};
		}
		else {
			push @{ $lines->[$line_number - 1]->{glyphs} }, {
				code     => $glyph_code,
				text     => $glyph_text,
				type     => $glyph_type,
				position => $glyph_position
			};
			$lines->[$line_number - 1]->{text} .= $glyph_text;
		}
	}

	$self->{_select_page_glyphs}->finish;

	return $lines;
}

sub get_ornament_glyph {
	my ($self, $name) = @_;

	my $sth;
	if (!defined $self->{_sth_ornament}) {
		$sth = ($self->{_sth_ornament} = $self->{_dbh}->prepare_cached(
		"SELECT g.glyph_code, gt.name FROM glyph g, glyph_type gt, ".
		"glyph_type gtp WHERE g.glyph_type_id = gt.glyph_type_id AND ".
		"gt.parent_id = gtp.glyph_type_id AND gtp.name = 'ornament' AND ".
		"gt.name = ?"));
	}
	else {
		$sth = $self->{_sth_ornament};
	}

	$sth->execute($name);

	my ($glyph_code, $glyph_type) = $sth->fetchrow_array;

	$sth->finish;

	return {
		code => $glyph_code,
		text => '&#'. $glyph_code .';',
		type => $glyph_type,
		position => 0
	};
}

sub _get_glyph_type {
	my ($self, $glyph_code, $page_number) = @_;

	$glyph_code =~ s/[^\d]*//g;

	my $sth;
	if (!defined $self->{_sth_glyph_type}) {
		$sth = ($self->{_sth_glyph_type} = $self->{_dbh}->prepare_cached(
		"SELECT gt.name FROM glyph_type gt, glyph g WHERE g.glyph_type_id = ".
		"gt.glyph_type_id AND g.glyph_code = ? AND g.page_number = ?"));
	}
	else {
		$sth = $self->{_sth_glyph_type};
	}

	$sth->execute($glyph_code, $page_number);

	my ($glyph_type) = $sth->fetchrow_array;

	$sth->finish;

	return $glyph_type? $glyph_type : '';
}

sub _get_word_lemma {
	my ($self, $glyph_code, $page_number) = @_;
	$glyph_code =~ s/[^\d]//g;

	my $sth;

	if (!defined $self->{_sth_word_lemma}) {
		$sth = ($self->{_sth_word_lemma} = $self->{_dbh}->prepare_cached(
		"SELECT wl.value FROM word_lemma wl, word w, glyph g WHERE ".
		"w.word_lemma_id = wl.word_lemma_id AND w.glyph_id = g.glyph_id AND ".
		"g.glyph_code = ? AND w.page_number = ?"));
	}
	else {
		$sth = $self->{_sth_word_lemma};
	}

	$sth->execute($glyph_code, $page_number);

	my ($word_lemma) = $sth->fetchrow_array;

	$sth->finish;

	return $word_lemma? $word_lemma : '';
}

1;
