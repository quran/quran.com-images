#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  .temp.pl
#
#        USAGE:  ./.temp.pl 
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:   (), <>
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  06/15/2009 10:01:16 AM CDT
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
my @dir = `ls output`;
do { $_ =~ s/\n//g; } for @dir;
for (@dir) {
	my $width = $_;
	my @dir = `ls output/$_`;
	do { $_ =~ s/\n//g; } for @dir;
	for (@dir) {
		my $em = $_;
		$width =~ s/width_//;
		$em =~ s/em_//;
		`./auto.pl -width $width -em $em -batch`;
	}
}
