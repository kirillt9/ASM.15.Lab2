#!/usr/bin/perl

use strict;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

use lib qw(/usr/www/asu/cgi-bin);

use lab2::st00::st00;
use lab2::st04::st04;
use lab2::st07::st07;
use lab2::st26::st26;
use lab2::st30::st30;
use lab2::st45::st45;
my @MODULES = 
(
	\&ST00::st00,
	\&ST04::st04,
	\&ST07::st07,
	\&ST26::st26,
	\&ST30::st30,
	\&ST45::st45,
);

my @NAMES = 
(
	"00. Sample",
	"04. Borisenko",
	"07. Gorinov",
	"26. Mikaelian",
	"30. Pereverzev",
	"45. Yazkov",
);


Lab2Main();

sub menu
{
	my ($q, $global) = @_;
	print $q->header();
	my $i = 0;
	print "<pre>\n------------------------------\n";
	foreach my $s(@NAMES)
	{
		$i++;
		print "<a href=\"$global->{selfurl}?student=$i\">$s</a>\n";
	}
	print "------------------------------</pre>";
}

sub Lab2Main
{
	my $q = new CGI;
	my $st = 0+$q->param('student');
	my $global = {selfurl => $ENV{SCRIPT_NAME}, student => $st};
	if($st && defined $MODULES[$st-1])
	{
		$MODULES[$st-1]->($q, $global);
	}
	else
	{
		menu($q, $global);
	}
}
