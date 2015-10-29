#!wperl.exe
package ST31;

use strict;
use warnings;
use CGI qw(param);

sub st31
{
	my %DbmFileHash = (); my @list = (); my $index = 0;
	my @Menu = (\&add, \&delete, \&edit, \&show, \&save, \&load, \&show_form);

	$Menu[5]->();

	if(param("name")&&param("club")){
		$Menu[0]->();
		$Menu[4]->();
	}elsif(param("edit_name")&&param("club")){
		$Menu[2]->(param("number")-1);
		$Menu[4]->();
	}elsif(param("delete")){
		$Menu[1]->(param("delete")-1);
		$Menu[4]->();
	}

	$Menu[3]->();


	sub add{
		my $href;
		$href = {"name", param("name"), "club", param("club")};
		push(@list, $href);
		return 1;
	}

	sub edit{
		${$list[$_[0]]}{"name"} = param("edit_name");
		${$list[$_[0]]}{"club"} = param("club");
		return 1;
	}

	sub delete{
		splice(@list,$_[0],1);
		return 1;
	}

	sub show{
		print <<"		END";
Content-Type:  text/html

		<HTML>
			<HEAD>
				<META charset="windows-1251">
				<TITLE>Market</TITLE>
			</HEAD>
			<BODY>
			<h1>TransferMarket</h1>
			<hr>
		END
		for(my $i = 0; $i < ($#list + 1); $i++){
			$index = $i+1;
			if(param("edit")==$index){
				$Menu[6]->("Edit player", "edit_name",$index,
								${$list[$i]}{"name"},
								${$list[$i]}{"club"}
								); 
			}else{
				print <<"				END";			
					<p><b>PLAYER $index:</b>
					<p><i>Name: ${$list[$i]}{"name"}
					<p>club: ${$list[$i]}{"club"}</i><p>
					<input type="button" value="Edit" onClick="location.href='?edit=$index';">
					<input type="button" value="Delete" onClick="location.href='?delete=$index';">
					<a href='#add';">Add player</a>
				END
			}
		}
		$Menu[6]->("Add New Player", "name", $index+1, "name", "club");
		print <<"		END";	
			</BODY>
		</HTML>
		END
	}

	sub save{
		dbmopen(%DbmFileHash, "dbfile", 0666) || die "can't open DBM file!\n";
		my $s; %DbmFileHash = ();
		for(my $i = 0; $i < ($#list + 1); $i++){
			$s = join("::",${$list[$i]}{"name"},
						   ${$list[$i]}{"club"});
			$DbmFileHash{"el".$i} = $s;
		}
		dbmclose(%DbmFileHash);
		return 1;
	}

	sub load{
		my ($name,$club,$href);
		dbmopen(%DbmFileHash, "dbfile", 0666) || die "can't open DBM file!\n";
		while((my $key, my $value) = each(%DbmFileHash)){
			($name,$club) = split(/::/,$value);
			$href = {"name", $name,"club", $club};
			push(@list, $href);
		}
		dbmclose(%DbmFileHash);
		return 1;
	}

	 sub show_form{
		print <<"		END";
			<a name="add"></a>
			<form>
				<hr><p><b>$_[0]</b>
				<i><input name="number" value=$_[2] size=4  readonly>
				<p>Enter name: <input name=$_[1] value=$_[3]>
				<p>Enter club: <input name="club" value=$_[4]></i>
				<p><input type="submit" value="Consent"></i>
				<p><input type="button" value="Start page" OnClick="location.href='lab2.pl';">
			</form><hr>
		END
		return 1;
	 }
}

1;

	