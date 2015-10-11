package ST00;
use strict;

use CGI;
use CGI::Carp qw(fatalsToBrowser);

sub st00
{
	my ($q, $global) = @_;
	print $q->header();
	print "<a href=\"$global->{selfurl}\">Back</a>";

}

1;

