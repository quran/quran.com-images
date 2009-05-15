#! /usr/bin/env perl

use strict;
use warnings;

use GD;
use DBI;

if (!$ARGV[0]){ die "please provide a directory name.\n"; }
my $dir = $ARGV[0];

my $db = "./data/sura_ayah_page_text.sqlite2.db";
my $dbh = DBI->connect("dbi:SQLite2:dbname=$db","","", 
                       { RaiseError => 1, AutoCommit => 0 });
my $sth = $dbh->prepare("select sura, ayah from sura_ayah_page_text order " .
                        "by sura asc, ayah asc");
$sth->execute();
while (my $row = $sth->fetchrow_hashref){
   my $sura = $row->{sura};
   my $ayah = $row->{ayah};
   print "$sura:$ayah\t" . getFirstX("$dir/$sura" . "_$ayah.png") . "\n";
}

sub getFirstX {
   my $image = newFromPng GD::Image($_[0]);
   (my $width, my $height) = $image->getBounds();

   for (my $x = $width; $x >= 0; $x--){
      for (my $y = 0; $y < $height; $y++){
         if ($image->getPixel($x, $y)){
            return $x;
         }
      }
   }
}
