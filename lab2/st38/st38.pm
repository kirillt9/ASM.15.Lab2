
package ST38;
use  strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);


my @list;
my $q = new CGI;
my $student	= $q->param('student');
my $event = $q->param('event');
my $id = $q->param('id'); 
	
sub st38 {

	my ($q, $global) = @_;
	print $q->header(-type=>"text/html",-charset=>"windows-1251");
	print "<a href=\"$global->{selfurl}\">В главное меню</a>";
	my %menu = (
	"add" => \&add,
	"edit" => \&edit,
	"delete" => \&delete);	

		if ($menu{$event}) 
	{
		$menu{$event}->();     
	}	else {
		load();  
		show();	
		}	 
}




sub add 
{
	load();
	my $man=
	{
		Name => $q->param('name'),
		Flat => $q->param('flat'),
		Surname => $q->param('surname'),
		Phone => $q->param('salary')
	};
	$list[$id]=$man;
	save();
	show();
}

sub edit 
{
	load();
	show();
}

 sub show 
 {
 	my ($q, $global) = @_;
	my $newid=@list;
	if ($event eq 'edit')	
	{ print "
	<form method = 'get'>
	<input type = 'hidden' name = 'student' value = '$student'/>
	<input type='hidden' name='event' value='add'>	<input type='hidden' name='id' value='$id'>	Имя:	<input type = 'text' name = 'name' value='$list[$id]->{Name}'>
		Фамилия:	<input type = 'text' name = 'surname' value='$list[$id]->{Surname}'>Квартира:	<input type = 'number' name = 'flat' min = 1 value='$list[$id]->{Flat}'>
	Телефон:	<input type = 'text' name = 'salary' value='$list[$id]->{Phone}'><BR><BR>	<input type = 'submit' value = 'Добавить'><BR><BR></form>";
	 save();
	 } else
			{
			print "
			<form method = 'get'>
			<input type = 'hidden' name = 'student' value = '$student'/>
			<input type='hidden' name='event' value='add'>
			<input type='hidden' name='id' value='$newid'>
			Имя:
			<input type = 'text' name = 'name'> 
			
			Фамилия:
			<input type = 'text' name = 'surname'>
			Квартира:
			<input type = 'number' name = 'flat' min = 1>
			Телефон:
			<input type = 'text' name = 'salary'><BR><BR>
			<input type = 'submit' value = 'Добавить'><BR><BR> </form>";
		
			}

	print "
		<table width='100%' border=2>
		<tr bgcolor = #F0FAFF>
		<th>ID</th><th>Имя</th><th>Фамилия</th><th>Квартира</th><th>Телефон</th><th>Изменить</th></tr>";
	 
	my $num=0;

	foreach my $arg(@list)
	{	
		print "
		<tr><td>$num</td>
		<td>$arg->{Name}</td>
		<td>$arg->{Surname}</td>
		<td>$arg->{Flat}</td>
		<td>$arg->{Phone}</td>
		<td><table><tr><td>
		
		<form method = 'get'>
		<input type = 'hidden' name = 'student' value = '$student'/>
		<input type='hidden' name='event' value='edit'>
		<input type='hidden' name='id' value='$num'>
		<input type = 'submit' value = 'Edit'></td>
		
		</form><td>
		<form method = 'get'>
		<input type = 'hidden' name = 'student' value = '$student'/>
		<input type='hidden' name='event' value='delete'>
		<input type='hidden' name='id' value='$num'>
		<input type = 'submit' value = 'Delete'></td>
		
		</tr>
		</table>
		</form>
		</tr>";
		$num++;
	}
	print "</table>";		 
 		
}

sub delete 
{
	load();
	splice(@list,$id,1);
	save();
	load();
	show();
}


 sub save
 {
	my %hash;
	dbmopen( %hash, "dbmfile", 0644);
	%hash=();
	my $j=0;
	foreach my $i(@list)
	{	
		$hash{$j}= join(":", $i->{Name},$i->{Flat},$i->{Surname},$i->{Phone});
		$j++;
	}
	dbmclose(%hash);
 }

 sub load
 {
	my %hash=();

	dbmopen(my %hash, "dbmfile", 0644);
	@list=();
		while (( my $key,my $value) = each(%hash))
	{
		 my @arg=split(/:/,$hash{$key});
		 my $man={
		  Name => "$arg[0]",
		  Flat => "$arg[1]",
		  Surname => "$arg[2]",
		  Phone => "$arg[3]"};
		 $list[$key]=$man;
	}
	
	dbmclose(%hash);
 }
 
 return 1;