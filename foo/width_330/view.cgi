#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  view.pl
#
#        USAGE:  ./view.pl 
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
#      CREATED:  09/19/2009 01:01:37 PM CDT
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use CGI;
use CGI::Carp qw/fatalsToBrowser/;
use Template;


my $cgi = new CGI;
my $params = $cgi->Vars;

$params->{page} = 1 if !defined $params->{page};

my $config = {
        POST_CHOMP => 1
};

my $template = Template->new($config);

my ($input, $output) = ('view.tt2', '');

my $page = {
        'previous'    => ($params->{page} - 1) || 0,
        'current' => (sprintf('%03d', $params->{page}))     || 001,
        'next'    => ($params->{page} + 1) || 2
};

$template->process($input, $page, \$output) || die $template->error();

print
        $cgi->header(
                -charset => 'utf-8'
        ),
        $output
;



