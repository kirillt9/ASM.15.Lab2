package ST03;
use strict;

use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Data::Dump qw(dump);

sub st03
{
	my ($q, $global) = @_;
	my @list;
	my @menu = (\&add, \&edit, \&delete, \&showTable, \&showBut);
	my %hash;
	
	sub showBut{
		my $name = undef;
		my $diplom = undef;
		print "<form method=\"post\">
			<input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
			<h1>List of diploma's themes</h1><br>";
			print "Student name: <input type=\"text\" name=\"name\" value=\"$name\"><br>";
			print "Student diploma theme: <input type=\"text\" name=\"diplom\" value=\"$diplom\">";
			
			print "	<button name=\"action\" type=\"submit\" value=\"0\">Add</button>";
			print "</form>";
	}
	
 	sub showTable{
		if((keys %hash) > 0)
		{	
			print "<table width = '100%' border=1>			
			<tr align = center>
				<td width = '30%'>Student</td>
				<td>Theme</td>
				<td width = '20%'>Actions</td>
			</tr>";
			while ( my ($key, $value) = each %hash )
			{
				my ($name, $diplom) = split(/--/, $value);
				print "<tr>
					<form method=\"post\">
					<input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
							
							<input type=\"hidden\" name=\"key\" readonly  value=\"$key\">					
					
						<td>	
							<input type=\"text\" name=\"name1\" value=\"$name\"><br>						
						</td>
						<td>
							<input type=\"text\" name=\"diplom1\" value=\"$diplom\"><br>
						</td>
						<td>
							<button name=\"action\" type=\"submit\" value=\"1\">Edit</button>
							<button name=\"action\" type=\"submit\" value=\"2\">Delete</button>
						</td>
				 	</form>
				 	<tr>";
				
			}
			
		}
		else
		{
			print "<tr colspan = 999><h2>List is empty</h2></tr>";
		}
		print"</table>";
	}
	
	sub add{
	
		my $name = $q->param('name');
		my $diplom =  $q->param('diplom');
		my $hashSize = scalar keys %hash;
		if ($diplom ne undef && $name ne undef){
			$hash{$hashSize+1} = join('--',$name, $diplom);
		}
	}
	
	sub edit{
		my $name = $q->param('name1');
		my $diplom =  $q->param('diplom1');
		my $key =  $q->param('key');
		if ($diplom ne undef && $name ne undef){
			$hash{$key} = join('--',$name, $diplom);
		}
	}
	
	sub delete{

		delete $hash{$q->param('key')};		
	}
	
	print $q->header;

	dbmopen(%hash, "dbm_03",0666);
	my $com = $q->param('action');
	if($com>=0 && $com<=2)
		{	
			@menu[$com]->();
		}
	@menu[4]->();
	@menu[3]->();
	print "<a href=\"$global->{selfurl}\">Back to main menu</a>";
	dbmclose(%hash);
}
1;

