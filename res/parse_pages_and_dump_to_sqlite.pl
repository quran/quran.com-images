#!/usr/bin/env perl
# bismillah in the name of allah most gracious, most merciful
# author nour sharabash
# vim: ts=2 sw=2 noexpandtab
use strict;
use warnings;
use DBI;

my $dbh = DBI->connect("dbi:SQLite2:dbname=sura_ayah_page_text.sqlite2.db","","", 
	{ RaiseError => 0, AutoCommit => 1 });

eval { $dbh->do("drop table sura_ayah_page_text"); };
$dbh->do("create table sura_ayah_page_text (
	sura integer,
	ayah integer,
	page integer,
	text text,
	primary key (sura, ayah)
);");

my $suras = {};
for (1..114) {
	$suras->{$_} = {};
}

for (1..604) {
	my $page = sprintf('%03d', $_);
	open my $fh, "./pages/$page.asp";
	while (my $line =  <$fh>) {
		next unless $line =~ s/^.*?onclick=ClickAyaArea\(([\d]+),([\d]+)\) target=_top>([^<]+)//;
		do {
			$suras->{$1}->{$2} = {
				page => $page,
				text => ''
			} if (!defined $suras->{$1}->{$2});
			$suras->{$1}->{$2}->{text} .= $3;
		} while $line =~ s/^.*?onclick=ClickAyaArea\(([\d]+),([\d]+)\) target=_top>([^<]+)//;
	}
	close $fh;
}

for (sort { $a <=> $b } keys %{$suras}) { # i.e. "for $suras keys, numerically sorted"
	my $sura = $_;
	my $ayas = $suras->{$_};
	for (sort { $a <=> $b } keys %{$ayas}) { # i.e. "for $ayas keys, numerically sorted"
		my $aya = $_;
		my $hash = $ayas->{$_};
		print  "$sura $aya ". $hash->{page} .' '. $hash->{text} ."\n";
		$dbh->do("insert into sura_ayah_page_text (sura, ayah, page, text) values ($sura, $aya, ". $hash->{page} .", ". $dbh->quote($hash->{text}) .");");
	}
}

$dbh->disconnect;
