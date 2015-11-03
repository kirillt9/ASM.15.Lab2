
package ST46;
use  strict;

my %flat;
my $q = new CGI;
my $student	= $q->param('student');
my $act = $q->param('act');


sub st46 {

	my ($q, $global) = @_;
	print $q->header(-type=>"text/html",-charset=>"windows-1251");
	print "<a href=\"$global->{selfurl}\">К списку лабораторных</a>";
	
	print "<br><a href=\"$global->{selfurl}?student=$student&act=show\">List of apartments</a>
	<br><a href=\"$global->{selfurl}?student=$student&act=FormAdd\">Add data</a>
	<br><a href=\"$global->{selfurl}?student=$student&act=FormEdit1\">Edit data</a>
	<br><a href=\"$global->{selfurl}?student=$student&act=FormDelete\">Delete data</a>";
	
	my %func = (
	"FormAdd" => \&FormAdd,
	"FormEdit1" => \&FormEdit1,
	"FormDelete" => \&FormDelete,
	"add" => \&add,
	"FormEdit2" => \&FormEdit2,
	"delete" => \&delete,
	"edit" => \&edit,
	"show" => \&show);
	
		if ($func{$act}) 
	{
		load();
		$func{$act}->(); 
	}	else {
		load();  
		show();	
		}
	 
	
}

 

sub FormAdd 
{
	print "<form method = 'get'>
	<input type = 'hidden' name = 'student' value = '$student'/>
	<input type='hidden' name='act' value='add'>
	<p>Номер квартиры:
	<input required type = 'number' name = 'number' min='1'<br>
	<p>Количество проживающих:
	<input type = 'text' name = 'men'> <br>
	<p>Количество комнат:
	<input type = 'text' name = 'room'><br>
	<p>Фамилия проживающих:
	<input type = 'text' name = 'surname'><br>
	<p><input type = 'submit' value = 'Add'></form>";
}

sub add 
{
	my $num = $q->param('number'); 
	my $men = $q->param('men');
	my $room = $q->param('room');
	my $surname = $q->param('surname');
	if (!exists $flat{$num})
	{
    $flat{$num}={Men =>$men,Room=>$room, Surname=> $surname};
	save();
	show();	
	}
	else
	{
	print "<p>!Flat with this number already exists!";
	}
}

sub FormEdit1 
{
	print "<form method='post'>
	<input type = 'hidden' name = 'student' value = '$student'/>
	<input type='hidden' name='act' value='FormEdit2'>
	<p>Выберите номер квартиры<br>
	<select name='number' size='5'>";
	
	foreach my $num (sort {$a<=>$b} keys %flat )
	{
	print "<option value='$num'>$num</option>";
	}
	print "</select>
	<p><input type='submit' value='Edit'></form>";
}


sub FormEdit2 
{
	my $num = $q->param('number');
	chomp($num);
	if (exists $flat{$num})
	{
	print "<form method='get'>
	<input type = 'hidden' name = 'student' value = '$student'/>
	<input type='hidden' name='act' value='edit'>
	<p>Номер квартиры:
	<input type = 'number' name = 'number' value='$num' readonly><br>
	<p>Количество проживающих:
	<input type = 'text' name = 'men' value='$flat{$num}->{Men}'> <br>
	<p>Количество комнат:
	<input type = 'text' name = 'room' value='$flat{$num}->{Room}'><br>
	<p>Фамилия проживающих:
	<input type = 'text' name = 'surname' value='$flat{$num}->{Surname}'><br>
	<p><input type = 'submit' value = 'Edit'></form>";
	}
	else 
	{
	print "<p>Mistake!Choose number of apartments for editing" ;} 
}


sub edit 
{
	my $num = $q->param('number');
	my $men = $q->param('men');
	my $room = $q->param('room');
	my $surname = $q->param('surname');
    $flat{$num}={Men =>$men,Room=>$room, Surname=> $surname};
	save();
	show();	
}

 sub show 
 {
	my ($q, $global) = @_;
	
	print "<table><tr bgcolor = #DDDDDD>
    <th>Number</th><th>Men</th><th>Room</th><th>Surname</th></tr>";
	
	foreach my $num (sort {$a<=>$b} keys %flat )
	{
	print "<tr><td>$num</td>";
		foreach my $val (sort keys %{$flat{$num}})
		{
		print"<td>$flat{$num}->{$val}</td>";
		}
    }	
	print "</table>";
	
 }

sub FormDelete 
{
	print "<form method='post'>
	<input type = 'hidden' name = 'student' value = '$student'/>
	<input type='hidden' name='act' value='delete'>
	<p>Выберите номер квартиры<br>
	<select name='number' size='5'>";
	foreach my $num (sort {$a<=>$b} keys %flat )
	{
	print "<option value='$num'>$num</option>";
	}
    print "</select>
	<p><input type='submit' value='Delete'></form>";

}
sub delete 
{
	my $num = $q->param('number');
	chomp($num);
	if (exists $flat{$num})
	{
	delete $flat{$num};
	save();
	show();
	}
	else
	{print "<p>Mistake!Choose number of apartments for deleting" ;}
}

 sub save
 {
	my %hash;
	dbmopen( %hash, "dbm", 0644);
	%hash=();
	foreach my $num(keys %flat)
	{	
		$hash{$num}=join("<>", $flat{$num}->{Men},$flat{$num}->{Room},$flat{$num}->{Surname});
	}
	dbmclose(%hash);
 }

 sub load
 {
    my %hash=();
	dbmopen(my %hash, "dbm", 0644);
	%flat=();
	while ((my $num,my $value) = each(%hash))
	{
	my @val=split(/<>/,$hash{$num});
	$flat{$num}={Men => "$val[0]", Room => "$val[1]",Surname => "$val[2]"};
	}
	dbmclose(%hash);
 }
 
 return 1;