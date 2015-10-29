#!/usr/bin/perl

use strict;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

use lib qw(/usr/www/asu/cgi-bin);

use lab2::st00::st00;
use lab2::st01::st01;
use lab2::st04::st04;
use lab2::st06::st06;
use lab2::st07::st07;
use lab2::st09::st09;
use lab2::st26::st26;
use lab2::st28::st28;
use lab2::st30::st30;
use lab2::st32::st32;
use lab2::st43::st43;
use lab2::st39::st39;
use lab2::st45::st45;
use lab2::st47::st47;


my @MODULES = 
(
	\&ST00::st00,
	\&ST01::st01,
	\&ST04::st04,
	\&ST06::st06,
	\&ST07::st07,
	\&ST09::st09,
	\&ST26::st26,
	\&ST28::st28,	
	\&ST30::st30,
	\&ST32::st32,
	\&ST43::st43,
	\&ST39::st39,
	\&ST45::st45,
	\&ST47::st47,
);

my @NAMES = 
(
	"00. Sample",
	"01. Baglikova",
	"04. Borisenko",
	"07. Goncharov",
	"07. Gorinov",
	"09. Greznev",
	"26. Mikaelian",
	"28. Nikolaeva",	
	"30. Pereverzev",
	"32. Pyatakhina",
	"43. Frolov",
	"39. Stupin",
	"45. Yazkov",
	"47. Utenov",
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
