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
use Cwd;


my $cgi = new CGI;
my $params = $cgi->Vars;

$params->{page} = 1 if !defined $params->{page} || $params->{page} !~ /^[\d]+$/ || $params->{page} < 1 || $params->{page} > 604;
$params->{width} = 1000 if !defined $params->{width} || $params->{width} !~ /^[\d]+$/ || $params->{width} < 100 || $params->{width} > 2000;

my $ok = 1;
my $target = './output/width_'. $params->{width} .'/'. $params->{page} .'.png';
if (!(-e $target)) {
	my $width = $params->{width};
	my $page = $params->{page};
	if (system('./generate.quran.page.pl','--width', $width,'--page',$page)) {
		$ok = 0;
	}
}

if ($ok) {

my $config = {
        POST_CHOMP => 1
};

my $template = Template->new($config);

my ($input, $output) = ('view.tt2', '');

my $page = {
        'previous'    => ($params->{page} - 1) || 0,
        'current' => (sprintf('%03d', $params->{page}))     || 001,
        'next'    => ($params->{page} + 1) || 2,
				'width'   => $params->{width}
};

$template->process($input, $page, \$output) || die $template->error();

print
        $cgi->header(
                -charset => 'utf-8'
        ),
        $output
;

}
else {
	print $cgi->header(
		-charset => 'utf-8',
		-content => 'text/html'
	), 'something went wrong';
}
