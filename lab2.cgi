#!/usr/bin/perl

use strict;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

use lib qw(/usr/www/asu/cgi-bin);

use lab2::st00::st00;
use lab2::st01::st01;
use lab2::st03::st03;
use lab2::st04::st04;
use lab2::st06::st06;
use lab2::st07::st07;
use lab2::st09::st09;
use lab2::st13::st13;
use lab2::st17::st17;
use lab2::st19::st19;
use lab2::st24::st24;
use lab2::st22::st22;
use lab2::st26::st26;
use lab2::st27::st27;
use lab2::st28::st28;
use lab2::st29::st29;
use lab2::st30::st30;
use lab2::st31::st31;
use lab2::st38::st38;
use lab2::st32::st32;
use lab2::st43::st43;
use lab2::st39::st39;
use lab2::st42::st42;
use lab2::st45::st45;
use lab2::st46::st46;
use lab2::st47::st47;


my @MODULES = 
(
	\&ST00::st00,
	\&ST01::st01,
	\&ST03::st03,
	\&ST04::st04,
	\&ST06::st06,
	\&ST07::st07,
	\&ST09::st09,
	\&ST13::st13,
	\&ST17::st17,
	\&ST19::st19,
	\&ST24::st24,
	\&ST22::st22,
	\&ST26::st26,
	\&ST27::st27,
	\&ST28::st28,
	\&ST29::st29,	
	\&ST30::st30,
	\&ST31::st31,
	\&ST38::st38,
	\&ST32::st32,
	\&ST43::st43,
	\&ST39::st39,
	\&ST42::st42,
	\&ST45::st45,
	\&ST46::st46,
	\&ST47::st47,
);

my @NAMES = 
(
	"00. Sample",
	"01. Baglikova",
	"03. Baranov",
	"04. Borisenko",
	"06. Goncharov",
	"07. Gorinov",
	"09. Greznev",
	"13. Zlotnikov",
	"17. Kirichenko",
	"19. Konstantinova",
	"24. Mamedov",
	"22. Lomakina",
	"26. Mikaelian",
	"27. Nikishaev",
	"28. Nikolaeva",
	"29. Novozhentsev",	
	"30. Pereverzev",
	"31. Podkolzin",
	"38. Stepenko",
	"32. Pyatakhina",
	"43. Frolov",
	"39. Stupin",
	"42. Umnikov",
	"45. Yazkov",
	"46. Bushmakin",
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
