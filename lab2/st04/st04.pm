#!/usr/bin/perl -w
package ST04;
use strict;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
my $q;
my $global;
#############Global Variables#############
my $header="";
my $content="";
my $run=1;
my %cash;
my $currentkeys=["Name","Status","Address","E-Mail"];
my $filename="st04";
#############Subroutines###############
#############
# getUID - generate unique number for store in $cash
# INPUT: none
# OUTPUT: NUMBER uid
#############
sub getUID{
    my $UID=0;
    for (keys %cash) {
	$UID=$_ if $UID<$_;
    }
    return $UID+1;
}
#############
# add - call menu for interactively add new item in the $cash
# INPUT: none
# OUTPUT: none
# return in st04
############
sub add{
    if ($q->param("Name")){
	 my @temp=();
	 foreach (@$currentkeys){
	    @temp=(@temp,$_,$q->param($_));
	}
	my $uid = getUID();
	$cash{$uid}=join (":::",@temp);
    }
}

#############
# correct - call menu for interactively correct existed item in the $cash
# INPUT: none
# OUTPUT: none
# return in st04
############
sub correct{
    if (my $UID=$q->param('UID')){
    if (defined %cash{$UID}){
	my @temp=();
	foreach (@$currentkeys){
	    @temp=(@temp,$_,$q->param($_));
	}
	$cash{$UID}=join (":::",@temp);
    }
    }
}

#############
# delete - call menu for interactively delete existed item in the $cash
# INPUT: none
# OUTPUT: none
# return in st04
############
sub delete{
    if (my $UID=$q->param('UID')){	    
	delete $cash{$UID};
    }
}

#############
# show - call menu for interactively show items in the $cash
# INPUT: none
# OUTPUT: none
 # return in st04
############

sub show{ 
    $content.= $q->start_table({ -border => 1,
				     -width  => "100%" });
    $content.= "\t".$q->th(["",@$currentkeys]);
    foreach my $key(keys %cash){
	my $temp={split(":::",%cash{$key})};
	$content.="\n<!--".join(":",keys (%cash))."; current $key-->\n";
	$content.="\t\t".$q->start_form."\n\t\t<tr>\n\t\t\t".$q->td(
				["\n\t\t\t".$q->hidden("student",$global->{student})."\n\t\t\t"."<input type=\"hidden\" name=\"UID\" value=\"$key\">"."\n\t\t\t".$q->submit("action","Delete")."\n\t\t\t".$q->submit('action',"Correct"),
				map{$q->textfield(-name=>"$_",
						  -override=>1,
						  -size=>20,
						  -maxlength=>30,
						  -value=>$temp->{$_})} @$currentkeys]
				)."\t\t</tr>\n\t\t\t".$q->end_form."\n";
    }
    $content.="\n".$q->start_form."\n\t<tr>\n\t\t<td>\n\t\t\t".$q->hidden("student",$global->{student})."\n\t\t\t".$q->submit('action',"Add")."\n\t\t</td>\n";
    $content.="\n\t\t<td>\n".(join("\n\t\t</td>\n\t\t<td>\n",map{"\t\t\t".$q->textfield(-name=>"$_",
							      -override=>1,
							      -size=>20,
							      -maxlength=>30)} @$currentkeys))."\n\t\t</td>\n";
    $content.="\t</tr>\n".$q->end_form;
    $content.=$q->end_table;
}

#############
# quit - exit point from st04
# INPUT: none
# OUTPUT: none
# return in st04
############
sub quit{
    print $q->redirect($global->{selfurl});
}
sub clear{
    %cash=();
}

sub Menu{
    
    $content.= "<H1>Lab2 by Borisenko</H1>\n";
    $content.= $q->start_form."\n";
    $content.="\t".$q->hidden("student",$global->{student})."\n";
    $content.="\t".$q->submit('action','Clear table')."\n";
    $content.="\t".$q->submit('action','Quit')."\n";
    $content.=$q->end_form."\n";
    show();
}
my $menuEntry={
    'Add'=>\&add,
    'Correct'=>\&correct,
    'Delete'=>\&delete,
    'Quit'=>\&quit,
    'Menu'=>\&Menu,
    'Clear table'=>\&clear
};

sub st04{
  ($q, $global) = @_;
  $content.= $q->start_html("Lab2 by Borisenko");
  dbmopen(%cash,"$filename",0666);
  if( my $act=$q->param('action')){
    $menuEntry->{$act}();
  }
  Menu();

  $content.= $q->end_html;
  $header.= $q->header(-type=>"text/html",
			  -charset=>"windows-1251");
  print $header;
  print $content;
  dbmclose(%cash);
}
1;
