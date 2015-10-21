#!/usr/bin/perl

package ST09;
use strict;

use CGI;
use CGI::Carp qw(fatalsToBrowser);

sub st09
{
	my ($q, $global) = @_;
	my %hash_obj=();
	
	
	sub AddEditForm{
		my $name="";
		my $family="";
		my $address="";
		my $edit_id="";
		my $act="add";
		if($q->param('Action') eq "send_edit"){
			my $id = $q->param('id');
			$edit_id= "<input type=\"hidden\" name=\"id\" value=\"$id\">";
			print "<h3>Editing</h3>";
			($name,$family,$address)=split(/#%/, %hash_obj{$id});
			$act="edit";
		}else{
			print "<h3>Add element</h3>";
		}
		
			print "
				<table>
				<form method=\"post\">
			 		<input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
					$edit_id
					<tr> <td>Name:</td>
						 <td><input type=\"text\" name=\"Name\" value=\"$name\"></td>
					</tr>
					<tr> <td>Family:</td>
				 		 <td><input type=\"text\" name=\"Family\" value=\"$family\"></td>
				 	<tr> <td>Address:</td>
				 		 <td><input type=\"text\" name=\"Address\" value=\"$address\"></td>
					</tr>
					<tr> <td></td>
						 <td><button name=\"Action\" type=\"submit\" value=\"$act\">Apply</button></td>
					</tr>
				</form>
				</table>";	
	}

	sub ListOfbj{
		
		print"<h2>List of customer </h2>";
		if(keys %hash_obj<0){
			print"<p>There is empty</p>";
		}else{
			
			print "<table>
				<tr>
					<td><h3>Name</h3></td><td><h3>Family</h3></td><td><h3>Address</h3></td>
				<tr>";
			while( my ($key,$value) =each %hash_obj){

				my ($name,$family,$address)=split(/#%/, $value);
				print"
				<tr>
					<form method=\"post\">
					 	<input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
					 	<input type=\"hidden\" name=\"id\" value=\"$key\">
						<td>$name</td>
						<td>$family</td>
						<td>$address</td>
						<td><button name=\"Action\" type=\"submit\"  value=\"send_edit\">Edit</button></td>
						<td><button name=\"Action\" type=\"submit\" value=\"del\">Delete</button></td>
					</form>
				</tr>";	
					
			}
			print"</table>";
		}
		print "<br>";
		
	}
	
	sub get_id
	{
		my $ret_id = -1;
		while ( my ($key, $value) = each %hash_obj )
		{
			if($key > $ret_id){
				$ret_id = $key;
			}
		}
		return $ret_id + 1;
	}
		
	my %function=(
		"add"=>sub{
			$hash_obj{get_id()}=join('#%',$q->param('Name'),
										$q->param('Family'),
										$q->param('Address') );	
		print("<td><p>Customer added</p>");
		},
		"edit"=>sub{
			$hash_obj{$q->param('id')}=join('#%',$q->param('Name'),
										$q->param('Family'),
										$q->param('Address') );	
		print("<p>Customer edeted</p>");
		},
		"del"=>sub{
			
			delete $hash_obj{$q->param('id')};
		print "<p>Customer deleted</p>";
		}
		
	);


	print $q->header(
		-type=>"text/html",
		-charset=>"windows-1251"
		
	);

	dbmopen(%hash_obj,"dbm_09",0644);
	my $ch=$q->param('Action');
	if(%function{$ch}){
		%function{$ch}->();
	}
	ListOfbj();
	AddEditForm();	

	dbmclose(%hash_obj);
	
	print "<a href=\"$global->{selfurl}\">Back</a>";
}

1;

