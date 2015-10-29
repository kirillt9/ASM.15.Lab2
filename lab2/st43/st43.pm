#!/usr/local/bin/perl

package ST43;
use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

my %library=();
my $q;
my $global;

sub st43
{

	my %functions = ('Add'=>\&Add, 'Delete'=>\&Delete, 'Edit'=>\&Edit);
	my ($q, $global) = @_;
	
	print $q->header( -type => "text/html", -charset => "windows-1251");
	print $q->start_html( -title => "Frolov" );
	print $q->h2("st::43\n");
	dbmopen (%library, "BooksAndInfo", 0644);
	
	my $temp=$q->param('Action');
	if(%functions{$temp})
	{
		%functions{$temp}->();
	}
	showAdd();
	
	show();
	
	dbmclose(%library);
	print "<br>";
	print "<a href=\"$global->{selfurl}\">Back</a>";
	

	
	sub showAdd
	{
		my $bookName="";
		my $publishYear="";
		my $publishHouse="";
		my $edit_id="";
		my $eff="Add";
		if ($q->param('Action') eq "Edit note"){
			my $id = $q->param('id');
			$edit_id= $q->hidden('id',$id);
			($bookName,$publishYear,$publishHouse)=split(/;/, %library{$id});
			$eff="Edit";
		}
		
		print $q->start_table;
		print $q->start_form(-method=>'post');
		print $q->hidden('student',$global->{student});
		print $q->hidden('edit_id',$edit_id);
		print $q->Tr(
					$q->td('Bookname'),
					$q->td ($q->textfield('Bookname',$bookName))
			  
		  );
		print $q->Tr(
					$q->td('Publishing Year'),
					$q->td ($q->textfield('publishYear',$publishYear))
			  
		  );
		print $q->Tr(
					$q->td('Publishing house'),
					$q->td ($q->textfield('publishHouse',$publishHouse))
			  
		  );
		print $q->Tr($q->td($q->submit('Action', $eff)));
		print $q->end_form;
		print $q->end_table;
		
	}
	
	
	sub show
	{
		
		
		print $q->start_table({ -border => 2,   -width  => "50%" });
		print $q->Tr( $q->th(['Bookname','Publishing Year','Publishing house']));
		foreach my $key (sort keys %library)
		{
			#my $temp2={split(";",%library{$id})};
			print $q->Tr(
				$q->start_form (-method=>'post'),
				$q->hidden('student',$global->{student}),
				$q->hidden('id',$key),
				$q->td ([split (";",%library{$key})]),
				# $q->td($bookName),
				# $q->td($publishYear),
				# $q->td($publishHouse),
				$q->td ($q->submit('Action', "Edit note")),
				$q->td ($q->submit('Action', "Delete")),
				$q->end_form
			);
			
		}
		print $q->end_table;
	}
	sub get_id
	{
		my $ret_id = 0;
		while ( my ($key, $value) = each %library )
		{
			if($key > $ret_id){
				$ret_id = $key;
			}
		}
		return $ret_id + 1;
	}

	sub Add
	{
		$library{get_id()}=join(';',$q->param('Bookname'),$q->param('publishYear'),$q->param('publishHouse'));
		
	}
	sub Edit
	{
		$library{$q->param('id')}=join(';',$q->param('Bookname'),$q->param('publishYear'),$q->param('publishHouse'));
	}
	sub Delete
	{
		delete $library{$q->param('id')};
	}
};

	

1;

