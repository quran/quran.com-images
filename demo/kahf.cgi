#!/usr/bin/env perl

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

my ($input, $output) = ('demo.tt2', '');

my $vars = {
	page_ayahs   => 5,
	page_prev    => ($params->{page} - 1) || 0,
	page_current => ($params->{page})     || 1,
	page_next    => ($params->{page} + 1) || 2,
	sura         => 18,
	width        => 460,
	em           => '1.2'
};
$vars->{ayah}    =  1 + $vars->{page_prev} * $vars->{page_ayahs};

$template->process($input, $vars, \$output) || die $template->error();

print
	$cgi->header(
		-charset => 'utf-8'
	),
	$output
;
