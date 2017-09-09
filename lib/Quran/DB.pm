package Quran::DB;

use strict;
use warnings;

use base qw/Quran/;

use DBI;

sub new {
	my $class = shift;
	my $config = shift;

	my $database = $config->{database} or die "database name needed";
	my $username = $config->{username} or die "database username needed";
	my $password = $config->{password} or die "database password needed";
	my $host = $config->{host} // 'localhost';
	my $port = $config->{port} // '3306';

	my $dbh = DBI->connect("dbi:mysql:database=".$database.";host=".$host.";port=".$port, $username, $password) or die;

	bless {
		_class => $class,
		_dbh   => $dbh
	}, $class;
}

sub reset_bounding_box_table {
	my ($self, $page) = @_;
	my $prep = $self->{_dbh}->prepare_cached("TRUNCATE glyph_page_line_bbox");
	$prep->execute();
}

sub get_page_lines {
	my ($self, $page) = @_;

	if (!defined $self->{_select_page_glyphs}) {
		$self->{_select_page_glyphs} = $self->{_dbh}->prepare_cached(
			"SELECT gpl.glyph_page_line_id, gpl.line_number, gpl.line_type, gpl.position, g.font_file, ".
			"g.glyph_code, gt.name FROM glyph_page_line gpl LEFT JOIN glyph g ON ".
			"g.glyph_id = gpl.glyph_id LEFT JOIN glyph_type gt ON g.glyph_type_id = ".
			"gt.glyph_type_id WHERE gpl.page_number = ? ORDER BY gpl.page_number ASC, ".
			"gpl.line_number ASC, gpl.position DESC");
	}

	$self->{_select_page_glyphs}->execute($page);

	my $lines = [];

	while (my ($glyph_page_line_id, $line_number, $line_type, $glyph_position,
			$line_font, $glyph_code, $glyph_type) = $self->{_select_page_glyphs}->fetchrow_array) {
		my $glyph_text = '&#'. $glyph_code .';';
		if (!defined $lines->[$line_number - 1]) {
			$lines->[$line_number - 1] = {
				number => $line_number,
				type   => $line_type,
				text   => $glyph_text,
				font   => Quran::FONT_DIR .'/'. $line_font,
				glyphs => [{
					page_line_id => $glyph_page_line_id,
					code         => $glyph_code,
					text         => $glyph_text,
					type         => $glyph_type,
					position     => $glyph_position
				}],
			};
		}
		else {
			push @{ $lines->[$line_number - 1]->{glyphs} }, {
				page_line_id => $glyph_page_line_id,
				code         => $glyph_code,
				text         => $glyph_text,
				type         => $glyph_type,
				position     => $glyph_position
			};
			$lines->[$line_number - 1]->{text} .= $glyph_text;
		}
	}

	$self->{_select_page_glyphs}->finish;

	return $lines;
}

sub set_page_line_bbox {
	my $self = shift;

	my ($glyph_page_line_id, $img_width, $min_x, $max_x, $min_y, $max_y) = @_;

	if (!defined $self->{_set_page_line_bbox}) {
		$self->{_set_page_line_bbox} = 1;
		$self->{_set_page_line_bbox_select} = $self->{_dbh}->prepare_cached(
			"SELECT glyph_page_bbox_id FROM glyph_page_line_bbox WHERE glyph_page_line_id = ? AND img_width = ?"
		);
		$self->{_set_page_line_bbox_insert} = $self->{_dbh}->prepare_cached(
			"INSERT INTO glyph_page_line_bbox (glyph_page_line_id, img_width, min_x, max_x, min_y, max_y) ".
			"VALUES (?, ?, ?, ?, ?, ?)"
		);
		$self->{_set_page_line_bbox_update} = $self->{_dbh}->prepare_cached(
			"UPDATE glyph_page_line_bbox SET min_x = ?, max_x = ?, min_y = ?, max_y = ? ".
			"WHERE glyph_page_line_id = ? AND img_width = ?"
		);
	}
	else {
		$self->{_set_page_line_bbox_select}->execute($glyph_page_line_id, $img_width);
		my @glyph_page_bbox_id = $self->{_set_page_line_bbox_select}->fetchrow_array;
		$self->{_set_page_line_bbox_select}->finish;

		if (scalar @glyph_page_bbox_id) {
			$self->{_set_page_line_bbox_update}->execute($min_x, $max_x, $min_y, $max_y, $glyph_page_line_id, $img_width);
			$self->{_set_page_line_bbox_update}->finish;
		}
		else {
			$self->{_set_page_line_bbox_insert}->execute($glyph_page_line_id, $img_width, $min_x, $max_x, $min_y, $max_y);
			$self->{_set_page_line_bbox_insert}->finish;
		}
	}
=cut

		$self->{_select_page_glyphs} = $self->{_dbh}->prepare_cached(
			"SELECT gpl.glyph_page_line_id, gpl.line_number, gpl.line_type, gpl.position, g.font_file, ".
			"g.glyph_code, gt.name FROM glyph_page_line gpl LEFT JOIN glyph g ON ".
			"g.glyph_id = gpl.glyph_id LEFT JOIN glyph_type gt ON g.glyph_type_id = ".
			"gt.glyph_type_id WHERE gpl.page_number = ? ORDER BY gpl.page_number ASC, ".
			"gpl.line_number ASC, gpl.position DESC");
	}

	$self->{_select_page_glyphs}->execute($page);
=cut
	return;
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

sub _get_word_val {
	my ($self, $key, $glyph_code, $page_number) = @_;

	my @keys = qw/arabic lemma root stem/;
	return if not grep $key eq $_, @keys;

	$glyph_code =~ s/[^\d]//g;

	my $sth;

	if (!defined $self->{"_sth_word_$key"}) {
		$sth = ($self->{"_sth_word_$key"} = $self->{_dbh}->prepare_cached(
		"SELECT wk.value FROM word_$key wk, word w, glyph g WHERE ".
		"w.word_$key"."_id = wk.word_$key"."_id AND w.glyph_id = g.glyph_id AND ".
		"g.glyph_code = ? AND w.page_number = ?"));
	}
	else {
		$sth = $self->{"_sth_word_$key"};
	}

	$sth->execute($glyph_code, $page_number);

	my ($word_val) = $sth->fetchrow_array;

	$sth->finish;

	return $word_val? $word_val : '';
}

1;
