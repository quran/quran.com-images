#! /usr/bin/env perl
# bismillah alra7man alra7eem
# in the name of Allah most gracious, most merciful
#
# data by: Kais Dukes and the Quranic Corpus team (corpus.quran.com)

use strict;
use warnings;
use DBI;

my $dbh = DBI->connect("dbi:SQLite2:dbname=corpus.sqlite2.db", "", "",
      { RaiseError => 0, AutoCommit => 1 });

# "if exists" doesn't work on sqlite2... go figure.
eval { $dbh->do("drop table corpus_mappings"); };
$dbh->do("create table corpus_mappings (
            corpus_id integer,
            page integer,
            sura integer,
            ayah integer,
            word integer,
            arabic text,
            qc_code text,
            lemmas text,
            primary key(corpus_id)
         );");

$dbh->do("create index sura_ayah_idx on corpus_mappings(sura, ayah)");
$dbh->do("create index page_idx on corpus_mappings(page)");

my $file = 'qcf_lemma_map.txt';
open HANDLE, $file or die "could not open qcf_lemma_map.txt: $!\n";

my $last_id = 0;
my $corpus_id = 1;
while (my $line = <HANDLE>){
   chomp($line);
   (my $sura, my $ayah, my $word, my $page, my $text, my $font, my $lemmas) =  
      split /\|/, $line;
   $dbh->do("insert into corpus_mappings(corpus_id, page, sura, ayah, " .
      "word, arabic, qc_code, lemmas) values($corpus_id, $page, $sura, " .
      "$ayah, $word, " . $dbh->quote($text) . ", '$font', " . 
      $dbh->quote($lemmas) . ");");
   $corpus_id++;

   if ($last_id ne $ayah){
      $last_id = $ayah;
      print "currently processing $sura:$ayah...\n";
   }
}
$dbh->disconnect;
