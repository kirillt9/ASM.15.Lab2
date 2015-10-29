#!wperl.exe
package ST06;

use 5.010;
use strict;
use warnings;
use CGI qw(param);

sub st06
{
	my %hdb = (); my @card_file = (); my $index = 0;
	my @functions = (\&add, \&edit, \&del, \&show, \&save, \&download, \&show_form);

	$functions[5]->();

	if(param("name")&&param("surname")){
		$functions[0]->();
		$functions[4]->();
	}elsif(param("edit_name")&&param("surname")){
		$functions[1]->(param("number")-1);
		$functions[4]->();
	}elsif(param("del")){
		$functions[2]->(param("del")-1);
		$functions[4]->();
	}

	$functions[3]->();

	#______FUNCTIONS______

	sub add{
		my $href;
		$href = {
				"name",   param("name"),
				"surname",param("surname"),
				"group",  param("group")
				};
		push(@card_file, $href);
		return 1;
	}

	sub edit{
		${$card_file[$_[0]]}{"name"} = param("edit_name");
		${$card_file[$_[0]]}{"surname"} = param("surname");
		${$card_file[$_[0]]}{"group"} = param("group");
		return 1;
	}

	sub del{
		splice(@card_file,$_[0],1);
		return 1;
	}

	sub show{
		print <<"		END";
Content-Type:  text/html

		<HTML>
			<HEAD>
				<META charset="windows-1251">
				<TITLE>Test</TITLE>
			</HEAD>
			<BODY>
			<h1>CARD FILE</h1>
			<hr>
		END
		for(my $i = 0; $i < ($#card_file + 1); $i++){
			$index = $i+1;
			if(param("edit")==$index){
				$functions[6]->("Edit person",
								"edit_name",
								$index,
								${$card_file[$i]}{"name"},
								${$card_file[$i]}{"surname"},
								${$card_file[$i]}{"group"}
								); 
			}else{
				print <<"				END";			
					<p><b>PERSON $index:</b>
					<p><i>Name: ${$card_file[$i]}{"name"}
					<p>Surname: ${$card_file[$i]}{"surname"}
					<p>Group: ${$card_file[$i]}{"group"}</i><p>
					<input type="button" value="Edit" onClick="location.href='?edit=$index';">
					<input type="button" value="Delete" onClick="location.href='?del=$index';">
					<a href='#add';">Add person</a>
				END
			}
		}
		$functions[6]->("Add new person",
						"name",
						$index+1,
						"name",
						"surname",
						"group"
						);
		print <<"		END";	
			</BODY>
		</HTML>
		END
	}

	sub save{
		dbmopen(%hdb, "dbfile", 0666) || die "can't open DBM file!\n";
		my $s; %hdb = ();
		for(my $i = 0; $i < ($#card_file + 1); $i++){
			$s = join("::",${$card_file[$i]}{"name"},
						   ${$card_file[$i]}{"surname"},
						   ${$card_file[$i]}{"group"});
			$hdb{"el".$i} = $s;
		}
		dbmclose(%hdb);
		return 1;
	}

	sub download{
		my ($name,$surname,$group,$href);
		dbmopen(%hdb, "dbfile", 0666) || die "can't open DBM file!\n";
		while((my $key, my $value) = each(%hdb)){
			($name,$surname,$group) = split(/::/,$value);
			$href = {
					"name",   $name,
					"surname",$surname,
					"group",  $group
					};
			push(@card_file, $href);
		}
		dbmclose(%hdb);
		return 1;
	}

	 sub show_form{
		print <<"		END";
			<a name="add"></a>
			<form>
				<hr><p><b>$_[0]</b>
				<i><input name="number" value=$_[2] size=4  readonly>
				<p>Enter name: <input name=$_[1] value=$_[3]>
				<p>Enter surname: <input name="surname" value=$_[4]>
				<p>Enter group: <input name="group" value=$_[5]></i>
				<p><input type="submit" value="Accept"></i>
				<p><input type="button" value="Start page" OnClick="location.href='lab2.pl';">
			</form><hr>
		END
		return 1;
	 }
}

1;

	