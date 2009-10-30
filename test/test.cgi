#!/usr/bin/env perl

use strict;
use warnings;

use CGI;
use CGI::Carp qw/fatalsToBrowser/;
use Template;


my $cgi = new CGI;
my $params = $cgi->Vars;

$params->{page} = 1 if !defined $params->{page};
$params->{width} = 320 if !defined $params->{width};

my $config = {
	POST_CHOMP => 1
};

my $template = Template->new($config);

my ($input, $output) = ('test.tt2', '');

my $vars = {
	page_prev    => ($params->{page} - 1) || 1,
	page_current => ($params->{page})     || 1,
	page_next    => ($params->{page} + 1) || 2,
	page_img     => (sprintf('%03d', $params->{page}) .".png"),
	width        => ($params->{width})    || 320
};

$template->process($input, $vars, \$output) || die $template->error();

print
	$cgi->header(
		-charset => 'utf-8'
	),
	$output
;
