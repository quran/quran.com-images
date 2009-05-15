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
   print "$sura:$ayah\t" . getLineCount("$dir/$sura" . "_$ayah.png") . "\n";
}

sub getLineCount {
   my $image = newFromPng GD::Image($_[0]);
   (my $width, my $height) = $image->getBounds();

   my @ranges = ();
   my $inRange = 0;
   for (my $y = 0; $y < $height; $y++){
      my $x;
      for ($x = $width; $x > 0; $x--){
         last if $image->getPixel($x, $y);
      }
      if ($x == 0){ $inRange = 1; }
      elsif ($inRange){ push(@ranges, $y); $inRange = 0; }
   }
   return join(",", @ranges);
}
