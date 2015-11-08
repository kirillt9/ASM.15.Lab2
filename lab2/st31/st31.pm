#!wperl.exe
package ST31;
use 5.010;
use strict;
use warnings;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI;


sub st31

{
my ($q, $global) = @_;
my @list = (); 
my %hash = ();

sub del{
	if(@_){
		splice(@list,$_[0]-1,1);
		save();
		return 1;
		}
}

sub save
{dbmopen(%hash, "dbmFile", 0666) ;

	my $f; %hash = ();
for(my $i = 0; $i < (scalar @list ); $i++)
{$f = join("::",${$list[$i]}{"name"}, ${$list[$i]}{"club"});
		  $hash{"rec".$i} = $f;}
		dbmclose(%hash);
		return 1;
}	

sub load{
my $name,my $club,my $record;
@list = (); %hash=();
dbmopen(%hash, "dbmFile", 0666) ;
while((my $key, my $value) = each(%hash)){
($name, $club) = split(/::/,$value);
$record = {	"name",$name,"club",$club};
push(@list, $record);}
	dbmclose(%hash);
		return 1;}	

sub show{
my $index = 0;
print header(-type=>'text/html',  -charset=>'windows-1251');
		
		print	"<Center><h1>TransferMarket</h1></Center><p><hr size = '5'>";
		
		for(my $i = 0; $i < (scalar @list ); $i++){
			 $index = $i+1;
			if(param("Edit")==$index){show_form("Edit player",
			$index,
			$list[$i]->{"name"},
			$list[$i]->{"club"});
			}else{
				print <<"				END";			
					<p><b>Player $index:</b>
					<p><i>Name: $list[$i]->{"name"}
					<p>Club: $list[$i]->{"club"}</i><p>
					<a href="?Edit=$index&student=$global->{student}">Edit player</a>
					<a href="?Del=$index&student=$global->{student}">Delete player</a>
					
				END
			}
	}
	show_form("Add new player",	$index+1);
	print "<a href=\"$global->{selfurl}\">Start page</a>";
}
	
  sub show_form{
		print <<"		END";
			<form>
				<hr ><p><b>$_[0]</b>
				<i><input type=hidden name="student" value=$global->{student}>
				<i><input type = "hidden" name="id" value=$_[1] readonly>
				<p>Enter name: <input name="name" value=$_[2]>
				<p>Enter club: <input name="club" value=$_[3]></i>
				<p><input type="submit" value="Apply"></i>
				
			</form><hr ><p><b>$_[0]</b>
		END
		return 1;
	 }
	
	
	sub add_edit_rec{
		if (@_){
			$list[$_[0]-1]->{"name"} = param("name");
			$list[$_[0]-1]->{"club"} = param("club");
			save();
			return 1;
		}	
	}
	
	
	
	load(); 	
		add_edit_rec(param("id"));
		del(param("Del"));
	
	show();
	
	
	}
1;

	
	
	