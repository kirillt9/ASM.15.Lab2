#!wperl.exe
package ST27;
use 5.010;
use strict;
use warnings;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI;


sub st27
{
my ($q, $global) = @_;
my @mass = (); my %hash = ();

sub del_rec{
	if(@_){
		splice(@mass,$_[0]-1,1);
		save_kart();
		return 1;
		}
}

sub save_kart
{dbmopen(%hash, "lib_kart", 0666) || die "can't open DBM file!\n";
##if(-e $lib_kart) {print "OK\n";}
	my $f; %hash = ();
for(my $i = 0; $i < (scalar @mass ); $i++)
{$f = join("##",${$mass[$i]}{"name"}, ${$mass[$i]}{"book"},${$mass[$i]}{"book_id"});
		  $hash{"rec".$i} = $f;}
		dbmclose(%hash);
		return 1;
}	

sub load_kart{
my $name,my $book,my $book_id,my $record;
@mass = (); %hash=();
dbmopen(%hash, "lib_kart", 0666) || die "can't open DBM file!\n";
while((my $key, my $value) = each(%hash)){
($name, $book, $book_id) = split(/##/,$value);
$record = {	"name",$name,"book",$book,"book_id",$book_id};
push(@mass, $record);}
	dbmclose(%hash);
		return 1;}	

sub show_kartoteka{
my $index = 0;
print header(-type=>'text/html',  -charset=>'windows-1251');
print start_html("Nikishaev Lab 2");
		
		print	"<Center><h1>Library`s Kartoteka</h1></Center><p><hr color = 'brown' size = '5'>";
		for(my $i = 0; $i < (scalar @mass ); $i++){
			 $index = $i+1;
			if(param("Edit")==$index){show_form("Edit record",
			$index,
			$mass[$i]->{"name"},
			$mass[$i]->{"book"},
			$mass[$i]->{"book_id"}); 
			}else{
				print <<"				END";			
					<p><b>Record $index:</b>
					<p><i>Name: $mass[$i]->{"name"}
					<p>Book: $mass[$i]->{"book"}
					<p>Book_id: $mass[$i]->{"book_id"}</i><p>
					<a href="?Edit=$index&student=$global->{student}">Edit record</a>
					<a href="?Del=$index&student=$global->{student}">Del record</a>
					
				END
			}
	}
	show_form("Add new record",	$index+1);
}
	
  sub show_form{
		print <<"		END";
			<form>
				<hr color = 'brown'><p><b>$_[0]</b>
				<i><input type=hidden name="student" value=$global->{student}>
				<i><input type = "hidden" name="id" value=$_[1] readonly>
				<p>Enter name: <input name="name" value=$_[2]>
				<p>Enter book: <input name="book" value=$_[3]>
				<p>Enter book_id: <input name="book_id" value=$_[4]></i>
				<p><input type="submit" value="Apply"></i>
			</form><hr color = 'brown'><p><b>$_[0]</b>
		END
		return 1;
	 }
	
	
	sub add_edit_rec{
		if (@_){
			$mass[$_[0]-1]->{"name"} = param("name");
			$mass[$_[0]-1]->{"book"} = param("book");
			$mass[$_[0]-1]->{"book_id"} = param("book_id");
			save_kart();
			return 1;
		}	
	}
	
	
	
	load_kart(); 	
		add_edit_rec(param("id"));
		del_rec(param("Del"));
	
	show_kartoteka();
	
	
	}
1;

	
	
	