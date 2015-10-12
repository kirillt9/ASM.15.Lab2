#!/usr/bin/perl -w
package ST04;
use strict;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
my $query = new CGI;
#############Global Variables#############
my $header="";
my $content="";
my $cookie;
my $count=0;
my $run=1;
my $cash={};
my $currentkeys=["Name","Status","Address","E-Mail"];
#############Subroutines###############
#############
# readCookies - fetch cookie from request
# INPUT: none
# OUTPUT: none
#############
sub readCookies(){
    my $cook={$query->cookie('cash')};
    while (my ($key,$val) = each %$cook) {
	my @data=split(':::', $val);
	$cash->{$key} ={@data};
    }
}
#############
# setCookies - set cookie to answer
# INPUT: none
# OUTPUT: none
#############
sub setCookies(){
    my %cookHash;
    for (keys %{$cash}) {	
	my @data=();
	while (my ($key,$val)=each %{$cash->{$_}}){
	    push @data, ($key. ':::' .$val);
	}
	$cookHash{$_}=join (':::',@data);
    }
    
    $cookie=$query->cookie(-name=>'cash',
			  -value=>\%cookHash,
			   -path=>'/cgi-bin/st04.cgi',
			   -expires=>'+10m');
}
#############
# showTable - create current cash table output
#############
sub showTable{
    $content.= $query->start_table({ -border => 1,
				     -width  => "100%" });
    $content.= $query->th(["UID",@$currentkeys]);
    foreach my $key(sort {$a<=>$b} keys (%$cash)){
	$content.="<tr>".$query->td([$key,
				     map{$cash->{$key}->{$_}
				     } @$currentkeys])."</tr>";
    }
    $content.= $query->end_table();
}
#############
# getUID - generate unique number for store in $cash
# INPUT: none
# OUTPUT: NUMBER uid
#############
sub getUID{
    my $UID=0;
    for (keys %$cash) {
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
    my $added=0;
    if ($query->param("Name")){
	 my @temp=();
	 foreach (@$currentkeys){
	    @temp=(@temp,$_,$query->param($_));
	}
	my $uid = getUID();
	 $cash->{$uid}={@temp};
	 $added=1;
    }
    $content.= "<H1>Adding new item</H1>";
    $content.= "Item was added" if ($added);
    $content.= $query->start_form;
    foreach (@$currentkeys){
	$content.= "<br>";
	$content.= "$_: ";
	$content.= $query->textfield(-name=>"$_",
				-override=>1,
				-size=>50,
				-maxlength=>80);
    }
    $content.="<br>";
    $content.= $query->submit('action','Add');
    $content.=$query->submit('action','Menu');
    $content.= $query->end_form;
}

#############
# correct - call menu for interactively correct existed item in the $cash
# INPUT: none
# OUTPUT: none
# return in st04
############
sub correct{
    $content.="<H1>Correction</H1>";
    my $corrected=0;
    if (my $UID=$query->param('UID')){	    
	my $aim=$cash->{$UID};
	foreach(@$currentkeys){
	    $aim->{$_}=$query->param($_);
	}
	$corrected=1;
    }
    $content.="<p>Correction done.</p>" if ($corrected);
    $content.= $query->start_form;
    $content.="UID for correction: ";
    $content.=$query->popup_menu(-name=>'UID',
				     -values=>[sort {$a<=>$b} keys %$cash]);
    foreach (@$currentkeys){
	$content.= "<br>";
	$content.= "$_: ";
	$content.= $query->textfield(-name=>"$_",
				-override=>1,
				-size=>50,
				-maxlength=>80);
    }
    $content.="<br>";
    $content.= $query->submit('action','Correct');
    $content.=$query->submit('action','Menu');
    $content.= $query->end_form;
    showTable();
    
}

#############
# delete - call menu for interactively delete existed item in the $cash
# INPUT: none
# OUTPUT: none
# return in st04
############
sub delete{
    $content.="<H1>Deletion</H1>";
    my $deleted=0;
    if (my $UID=$query->param('UID')){	    
	delete $cash->{$UID};
	$deleted=1;
    }
    $content.="<p>Item was deleted.</p>" if ($deleted);
    $content.= $query->start_form;
    $content.="UID for deletion: ";
    $content.=$query->popup_menu(-name=>'UID',
				     -values=>[sort {$a<=>$b} keys %$cash]);
    $content.="<br>";
    $content.=$query->submit('action','Delete');
    $content.=$query->submit('action','Clear table');
    $content.=$query->submit('action','Menu');
    $content.=$query->end_form;
    showTable();
}

#############
# show - call menu for interactively show items in the $cash
# INPUT: none
# OUTPUT: none
 # return in st04
############

sub show{
    $content.= "<H1>Current table</H1>";
    showTable();
    $content.="<br>";
    $content.=$query->start_form;
    $content.=$query->submit('action','Menu');
    $content.=$query->end_form;
}

#############
# save - call menu for interactively save $cash to dbm file
# INPUT: none
# OUTPUT: none
# return in st04
############
sub save{
    $content.="<h1>Saving</h1>";
    my $saved=0;
    my $filename=$query->param('filename');
    if  ($filename){
	my %localdbm;
	dbmopen(%localdbm,"$filename",0777) or $content.="<p>Can't create $filename</p>";
	for (keys %{$cash}) {	
	    my @data=();
		while (my ($key,$val)=each %{$cash->{$_}}){
		    push @data, ($key. ':::' .$val);
		}
	    $localdbm{$_}=join (':::',@data);
	}
	dbmclose(%localdbm);
	$saved=1;
    }
    $content.="<p>Table saved to $filename</p>" if ($saved);
    $content.=$query->start_form;
    $content.="Name of file to save: ";
    $content.=$query->textfield(-name=>"filename",
				-override=>1,
				-value=>"data",
				-size=>20,
				-maxlength=>30);
    $content.=$query->submit('action','Save');
    $content.="<br>";
    $content.=$query->submit('action','Menu');
    $content.=$query->end_form;
}

#############
# load - call menu for interactively load data from dbm file and put it to $cash
# INPUT: none
# OUTPUT: none
# return in st04
############
sub load{
    $content.="<h1>Loading</h1>";
    $content.="<h5>Current table will be erased!</h5>";
    my $loaded=0;
    my $filename=$query->param('filename');
    if  ($filename){
	$cash={};
	my %localdbm;
	dbmopen(%localdbm,"$filename",0) or $content.="<p>Can't open $filename</p>";
	while (my ($key,$val) = each %localdbm) {
	    $cash->{$key}={split ':::', $val};
	    
	}
	dbmclose(%localdbm);
	$loaded=1;
    }
    $content.="<p>Table loaded from $filename</p>" if ($loaded);
    $content.=$query->start_form;
    $content.="Name of file to load: ";
    $content.=$query->textfield(-name=>"filename",
				-override=>1,
				-value=>"data",
				-size=>20,
				-maxlength=>30);
    $content.=$query->submit('action','Load');
    $content.="<br>";
    $content.=$query->submit('action','Menu');
    $content.=$query->end_form;   
}

#############
# quit - exit point from st04
# INPUT: none
# OUTPUT: none
# return in st04
############
sub quit{
    $run=0;
}
sub clear{
    $cash={};
    &delete();
}

sub Menu{
    
    $content.= "<H1>Lab2 by Borisenko</H1>\n";
    $content.= $query->start_form;
    $content.= $query->submit('action','Add');
    $content.=$query->submit('action','Correct');
    $content.=$query->submit('action','Delete');
    $content.=$query->submit('action','Show');
    $content.=$query->submit('action','Save');
    $content.=$query->submit('action','Load');
    $content.=$query->submit('action','Quit');
    $content.= $query->end_form;
}
my $menuEntry={
    'Add'=>\&add,
    'Correct'=>\&correct,
    'Delete'=>\&delete,
    'Show'=>\&show,
    'Save'=>\&save,
    'Load'=>\&load,
    'Quit'=>\&quit,
    'Menu'=>\&Menu,
    'Clear table'=>\&clear
};

sub st04{
my ($q, $global) = @_;
readCookies();
$content.= $query->start_html("Lab2 by Borisenko");
if( my $act=$query->param('action')){
    $menuEntry->{$act}();
}else{
    Menu();
}
$content.= $query->end_html;
if ($run){
setCookies();
$header.= $query->header(-type=>"text/html",
			 -charset=>"windows-1251",
			 -cookie=>$cookie);
print $header;
print $content;
}else{
    print $query->redirect($global->{selfurl});
}
}
1;
