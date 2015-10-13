#!perl.exe -w
package ST30;
use strict;
use CGI;
use Data::Dump qw(dump);

sub st30
{
	my ($q, $global) = @_;
	my %buffer;

	sub get_uid
	{
		my $uid = -1;
		while ( my ($key, $value) = each %buffer )
		{
			if($key > $uid)
			{
				$uid = $key;
			}
		}
		return $uid + 1;
	}

	sub show_table
	{
		print "<table>
			<tr colspan = 999><h1>Телефонная книга</h1></tr>";
		if((keys %buffer) > 0)
		{
			print "<tr>
					<td><b>Имя</b></td>
				 	<td><b>Телефон</b></td>
				</tr>";
			while ( my ($key, $value) = each %buffer )
			{
				my ($name, $phone) = split(/--/, $value);
				print "<tr>
					<form method=\"post\">
						<input type=\"hidden\" name=\"id\" value=\"$key\">
				  		<td>$name</td>
				  		<td>$phone</td>
				  		<td>
				  			<button name=\"action\" type=\"submit\" value=\"to_edit\">Редактировать</button>
				  			<button name=\"action\" type=\"submit\" value=\"delete\">Удалить</button>
				  		</td>
				 	</form>
				 	<tr>";
			}
		}
		else
		{
			print "<tr colspan = 999><h2>Телефонная книга пуста! Добавьте хотя бы одну запись, используя форму внизу</h2></tr>";
		}
		print "</table><br>";
	}

	sub show_form
	{
		my $action = "add";
		my $title = "Добавить новую запись";
		my $hidden_param = "";
		my $name = "";
		my $phone = "";
		if($q->param('action') eq 'to_edit') 
		{
			my $id = $q->param('id');
			($name, $phone) = split(/--/, $buffer{$id});
			$hidden_param = "<input type=\"hidden\" name=\"id\" value=\"$id\">";
			$action = "edit";
			$title = "Редактировать запись";
		}
		print "<hr><form method=\"post\">
		  	<p><h2>$title</h2></p>
		  	$hidden_param
		  	<p>Имя:&nbsp<input type=\"text\" name=\"name\" value=\"$name\"></p>
		  	<p>Номер телефона:&nbsp<input type=\"text\" name=\"phone\"  value=\"$phone\"></p>
	  		<p><button name=\"action\" type=\"submit\" value=\"$action\">Сохранить</button></p>
	 	</form>";
	}

	sub validate 
	{
		my ($id) = @_;
		my $name = $q->param('name');
		my $phone =  $q->param('phone');
		if(($name ne "") and ($phone ne ""))
		{
			$buffer{$id} = join('--',$name, $phone);
		}
		else 
		{
			print "Поля <Имя>, <Номер телефона> не могут быть пустыми";
		}
	}

	my %commands = (
		'edit' => sub {
			validate($q->param('id'));
		},
		'delete' => sub {
			delete $buffer{$q->param('id')};
		},
		'add' => sub {
			validate(get_uid());	
		}
	);

	print $q->header(
		-type=>"text/html",
		-charset=>"windows-1251"
	);
	dbmopen(%buffer, "db", 0644);
	my $command = $q->param('action');
	if (defined $commands{$command}) 
	{
		$commands{$command}->();	
	}
	show_table();
	show_form();
	dbmclose(%buffer);
}

1;