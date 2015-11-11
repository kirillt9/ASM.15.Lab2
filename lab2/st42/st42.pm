package ST42;
use strict;

use CGI;
use CGI::Carp qw(fatalsToBrowser);

sub st42
{
	my ($q, $global) = @_;
	print $q->header(-type => "text/html", -charset => "windows-1251");
	print $q->start_html(-title => "Umnikov АСМ-15-04");
	print "<a href=\"$global->{selfurl}\">Back</a>";
	my %menu = (
	"Add to list" => \&add,
	"Edit" => \&edit,
	"Delete" => \&delete_object);

	
	sub add
	{
	dbmopen(my %hash,"mylist",0644) or die;
		$hash{scalar keys %hash} = join("::",
		$q->param('name'),
		$q->param('surname'), 
		$q->param('hometown')) if ($q->param('name') ne "" && $q->param('surname') ne "" && $q->param('hometown') ne "");
	dbmclose (%hash);
	$q->delete_all();
	}
	
	sub delete_object
	{
	dbmopen(my %hash,"mylist",0644) or die;
	my $item = $q->param('item');
	my $size = scalar keys %hash;
	
	if ($item < $size - 1)
	{
	for (my $i= $item; $i< $size - 1;$i++ )
	{
		$hash{$i} = $hash{$i+1};
	}
	}	
	delete ($hash{$size - 1});
	dbmclose (%hash);	
	$q->delete_all();
	}
	
	sub edit
	{
	my $item = $q->param('item');
	dbmopen(my %hash,"mylist",0644) or die;
		$hash{$item} = join("::",
		$q->param('name'),
		$q->param('surname'), 
		$q->param('hometown')) if ($q->param('name') ne "" && $q->param('surname') ne "" && $q->param('hometown') ne "");
	dbmclose (%hash);
	$q->delete_all();
	}
	
	sub show 
	{
		print $q->h1("List");
		print $q->start_form;
		print $q->table(
			$q->Tr("Enter a person:"),
			$q->Tr(
				$q->td($q->textfield(-name => "name",-placeholder => "Name", -size => 30)),
				$q->td($q->textfield(-name => "surname",-placeholder => "Surmane", -size => 30)),
				$q->td($q->textfield(-name => "hometown",-placeholder => "Hometown", -size => 30)),
				$q->td($q->submit(-name=>'action',-value => "Add to list"))
			)
		);
		
		print $q->hidden('person',$global->{'person'});
		print $q->end_form;
		
		
		print $q->br;
		print $q->hr;
		print $q->br;
		
		print $q->start_table();
		
		
		print $q->Tr ( 
		$q->th("№"),
		$q->th("Name"),
		$q->th("Surname"),
		$q->th("Hometown"),
		$q->th()
		);
		
		dbmopen(my %hash,"mylist",0644) or die;
		foreach my $k (sort keys %hash)
		{
			
			print $q->start_form;
			print $q->hidden(-name => 'item', -value => $k);
			print $q->hidden('person',$global->{'person'});
			
			my @val = split(/::/,$hash{$k});
			
			print $q->Tr ( 
			$q->td($k+1),
			$q->td($q->textfield(-name => "name",-size => 30, -value => $val[0])),
			$q->td($q->textfield(-name => "surname",-size => 30, -value => $val[1])),
			$q->td($q->textfield(-name => "hometown",-size => 30, -value => $val[2])),
			$q->td($q->submit(-name=>'action',-value => "Edit"),
					$q->submit(-name=>'action',-value => "Delete"))
			);	
			print $q->end_form;
		}
		if (!%hash) 
		{
			print $q->Tr ($q->td({-colspan => 5}, "Empty list"));
		}
		dbmclose (%hash);
		
		print $q->end_table;
	}
	
	if ($menu{$q->param('action')}) {$menu{$q->param('action')}->();} 
	show();
	print $q->end_html;
}

1;
