
package ST33;
use  strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);


my @list;
my $q = new CGI;
my $student	= $q->param('student');
my $event = $q->param('event');
my $id = $q->param('id'); 
	
sub st33 {

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
		Group => $q->param('group'),
		TelefonNumber => $q->param('telefonnumber')
		
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
	<input type='hidden' name='event' value='add'>
	<input type='hidden' name='id' value='$id'>
	<P>Имя:
	<input type = 'text' name = 'name' value='$list[$id]->{Name}'> <BR>
	<P>Группа:
	<input type = 'number' name = 'group' min = 14 value='$list[$id]->{Group}'><BR>
	<P>Должность:
	<input type = 'text' name = 'telefonnumber' value='$list[$id]->{TelefonNumber}'><BR><BR>
	
	<input type = 'submit' value = 'Edd employee'><BR><BR></form>";
	 save();
	 } else
			{
			print "
			<form method = 'get'>
			<input type = 'hidden' name = 'student' value = '$student'/>
			<input type='hidden' name='event' value='add'>
			<input type='hidden' name='id' value='$newid'>
			<P>Имя:
			<input type = 'text' name = 'name'> <BR>
			<P>Группа:
			<input type = 'number' name = 'group' min = 14><BR>
			<P>Телефонный номер:
			<input type = 'text' name = 'telefonnumber'><BR><BR>
			
			<input type = 'submit' value = 'Add employee'><BR><BR> </form>";
		
			}

	print "
		<table>
		<tr bgcolor = #green>
		<th>ID</th><th>Name</th><th>Group</th><th>TelefonNumber</th><th>Change</th>";
	 
	my $num=0;

	foreach my $arg(@list)
	{	
		print "
		<tr><td>$num</td>
		<td>$arg->{Name}</td>
		<td>$arg->{Group}</td>
		<td>$arg->{TelefonNumber}</td>

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
		$hash{$j}= join(":", $i->{Name},$i->{Group},$i->{TelefonNumber});
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
		  Group => "$arg[1]",
		  TelefonNumber => "$arg[2]"
		 };
		 $list[$key]=$man;
	}
	
	dbmclose(%hash);
 }
 
 return 1;