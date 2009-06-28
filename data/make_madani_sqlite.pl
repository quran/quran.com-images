#!/usr/bin/env perl
# bismillah - in the name of Allah most gracious, most merciful
# author nour sharabash
# author ahmed el-helw
# vim: ts=2 sw=2 noexpandtab
use strict;
use warnings;
use DBI;

my $dbh = DBI->connect("dbi:SQLite2:dbname=madani.sqlite2.db","","", 
	{ RaiseError => 0, AutoCommit => 1 });

eval { $dbh->do("drop table madani_page_text"); };
$dbh->do("create table madani_page_text (
	page integer,
	line integer,
	sura integer,
	ayah integer,
	text text,
	primary key (page, line)
);");

my $pages = {};
my $cursura = 0;
for (1..604) {
	$pages->{$_} = {};
	my $line_num = 1;
	my $page_num = $_;
	my $page = sprintf('%03d', $_);
	open my $fh, "./pages/$page.asp";
	while (my $line =  <$fh>) {
		# if there's a center and /center, ayah is 0 and the text is bismillah
		# a break indicates a new line in the ayah.
		if ($line =~ s/^.*?onclick=ClickAyaArea\(([\d]+),([\d]+)\) target=_top>(<center>)?([^<]+)(<\/center>)?<\/A>(<br>)?//){
			do {
				if ($pages->{$page_num}->{$line_num}){
					$pages->{$page_num}->{$line_num}->{text} .= $4;
				}
				else {
					$pages->{$page_num}->{$line_num} = {
						sura => $1,
						ayah => $2,
						text => $4
					};
				}
				if (($2==0) || (defined($6))){ $line_num++; }	
			} while ($line =~ s/^.*?onclick=ClickAyaArea\(([\d]+),([\d]+)\) target=_top>(<center>)?([^<]+)(<\/center>)?<\/A>(<br>)?//);
		}
		# this indicates a header for the sura at hand, and the sura name is text
		elsif ($line =~ s/^.*?align="center" class=sc_F1>([^<]+)//){
			$cursura++;
			$pages->{$page_num}->{$line_num} = {
				sura => $cursura,
				text => $1 
			};
			$line_num++;
		}	
	}
	close $fh;
}

for (1..604){
	my $page = $_;
	my $line = 1;
	while (defined $pages->{$page}->{$line}){
		# ayah is null for titles, 0 for non-fatiha bismillah, and 1+ for ayahs
		my $ayah = 'null';
		my $hash = $pages->{$page}->{$line};
		my $sura = $hash->{sura};
		my $text = $hash->{text};

		# fix the weird spacing issue found in some asp pages for some ayahs
		$text =~ s/; &/;&/g;
		if (defined($hash->{ayah})){ $ayah = $hash->{ayah}; }

		$dbh->do("insert into madani_page_text (page, line, sura, ayah, text ) " .
			"values($page, $line, $sura, $ayah, " .
			$dbh->quote($text) . ");");
		$line++;
	}
}

$dbh->disconnect;
