#!/usr/local/bin/perl

package ST38;

use CGI;

use strict;
print "Content-type: text/html\n\n"; 

sub st38{
my $selfurl='2.cgi';
menu();
     
	sub menu
{
		
	my %t=('add'=>\&Add,'edit'=>\&Edit,'delete'=>\&Delete,'addE'=>\&AddE);
	my $q=new CGI;
	my %FILE;
   	dbmopen(%FILE, "38", 0666);
	my $type = $q->param("type");
	PrintH();
	$t{$type}->($q, \%FILE) if(defined $t{$type});
 my $fut;
	Add2();
	PrintForm();
	Board($q,\%FILE);
	PrintFooter($q);
	dbmclose(%FILE);
    #PrintList();
	#PrintFooter();
}
sub PrintForm
{   my ($q,$data)=@_;
	print 	<<ENDOFHTML;
<h2>Список жильцов дома:</h2>
<form action=$selfurl method=post>
<table border=0>
<tr>
<td  bgcolor="#9932CC" width=57><b>Номер</b></td>
<td  bgcolor="#9932CC" width=207><b>Фамилия</b></td>
<td  bgcolor="#9932CC" width=207><b>Имя</b></td>
<td  bgcolor="#9932CC" width=87><b>Квартира</b></td>
<td  bgcolor="#9932CC" width=87><b>Телефон</b></td>
</tr>
</form>


ENDOFHTML

} 	

         
sub PrintH{ 
my($q, $data) = @_;
print 	<<ENDOFHTML;
<html>
<head>
<title>
Список жильцов</title>
</head>
<body>


ENDOFHTML
}
 sub Board
{

	my($q, $data) = @_;
	foreach my $key(sort keys %$data)
	{
		next if($key eq '!!!ID!!!');
		PrintList($key, $data);
	}

#	print "<br>";

}


sub PrintList
{
   my ($id,$data)=@_;

	my ($Sname,$Name,$NumFlat,$NumTel)=split(/::/,$data->{$id});

print 	<<ENDOFHTML;
<form action=$selfurl method=post>
<table border=0>
<tr>
<td  bgcolor="#DDAODD"><input type=text size=5 name=Number value="$id"></td>
<td  bgcolor="#DDAODD"><input type=text size=30 name=Surname placeholder="Фамилия" value="$Sname"></td>
<td  bgcolor="#DDAODD"><input type=text size=30 placeholder="Имя" name=Name value="$Name"></td>
<td  bgcolor="#DDAODD"><input type=text size=10 maxlength=3  max=200 min=1 name=NumFlat value="$NumFlat"></td>
<td  bgcolor="#DDAODD"><input type=text size=10  name=NumTel value="$NumTel"></td>
<td><a href="$selfurl?type=delete&id=$id">&laquo;Delete&raquo;</a>
<a href="$selfurl?type=edit&id=$id'">&laquo;Edit&raquo;</a>
</tr></form>


ENDOFHTML
	
} 
  sub PrintFooter
{
	my($q, $data) = @_;
	print <<ENDOFHTML;
</body>
</html>
ENDOFHTML
}


sub Add
{
   	my($q, $data) = @_;
	my $id =0+$q->param("id");
	$id = ++$data->{'!!!ID!!!'} unless($id);
	$data->{$id} = join('::', $q->param('Surname'), $q->param('Name'), $q->param('NumFlat'),$q->param('NumTel'));
}

sub Add2
{
	my ($q,$data)=@_;
 	PrintForm2();
my ($Sname,$Name,$NumFlat,$NumTel);

print 	<<ENDOFHTML;
<form action=$selfurl method=post>
<input type=hidden name=type value='add'>
<table border=0>
<tr>
<td  bgcolor="#B8860B"><input type=text size=30 name=Surname placeholder="Фамилия" value="$Sname"></td>
<td  bgcolor="#B8860B"><input type=text size=30 placeholder="Имя" name=Name value="$Name"></td>
<td  bgcolor="#B8860B"><input type=number size=10 placeholder="000"  maxlength=3 max="200" min="1" name=NumFlat value="$NumFlat"></td>
<td  bgcolor="#B8860B"><input type=tel size=10  placeholder="xxx-xxx-xxxx" maxlength=10  name=NumTel value="$NumTel"></td>
</td> 
</tr>
</table>
<input type=submit value=" Добавить ">
<br><br> 
</form>                                      
ENDOFHTML
		
}
sub PrintForm2
{   my ($q,$data)=@_;
print 	<<ENDOFHTML;
<form action=$selfurl method=post>
<table border=0>
<tr>
<td  bgcolor="#FFD700" width=207><b>Фамилия</b></td>
<td  bgcolor="#FFD700" width=207><b>Имя</b></td>
<td  bgcolor="#FFD700" width=87><b>Квартира</b></td>
<td  bgcolor="#FFD700" width=87><b>Телефон</b></td>
</tr>
</form>
ENDOFHTML

} 	
sub Delete
{
    my($q, $data) = @_;
	my $id = 0+$q->param("id");
	delete $data->{$id} if($id);
}

sub Edit
{  
    my($q,$data) = @_;       
	my $id = 0+$q->param("id");
	my ($Sname,$Name,$NumFlat,$NumTel)=split(/::/,$data->{$id});
 	PrintForm2();

print 	<<ENDOFHTML;
<h3>Редактирование выбранных данных:</h3>
<form action=$selfurl method=post>
<table border=0>
<tr>
<td  bgcolor="#B8860B"><input type=hidden size=30 name=id  value="$id"></td>
<td  bgcolor="#B8860B"><input type=text size=30 name=Surname  value="$Sname"></td>
<td  bgcolor="#B8860B"><input type=text size=30 placeholder="Имя" name=Name value="$Name"></td>
<td  bgcolor="#B8860B"><input type=text size=10 maxlength=3 max=200 min=1 name=NumFlat value="$NumFlat"></td>
<td  bgcolor="#B8860B"><input type=tel size=10   name=NumTel value="$NumTel"></td>
</td> 
</tr>
</table>
<input type=submit value=" Редактировать ">
<input type=hidden name=type value='addE'> </form>
<br><br><br><br>
ENDOFHTML
     
}

sub AddE
{
   	my($q,$data) = @_;
	my $id =0+$q->param('id');
	$data->{$id} = join('::', $q->param('Surname'), $q->param('Name'), $q->param('NumFlat'),$q->param('NumTel'));
}
}