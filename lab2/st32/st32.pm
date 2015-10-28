package ST32;
use strict;

use CGI;
use CGI::Carp qw(fatalsToBrowser);

sub st32
{
	my ($q, $global) = @_;
	print $q->header(-type => "text/html", -charset => "windows-1251");
	print $q->start_html(-title => "Пятахина АСМ-15-04");
	print "<a href=\"$global->{selfurl}\">Back</a>";
	my %menu = (
	"Добавить в список" => \&add,
	"Редактировать" => \&edit,
	"Удалить" => \&delete_object);

	
	sub add
	{
	dbmopen(my %hash,"mylist",0644) or die;
		$hash{scalar keys %hash} = join("::",
		$q->param('name'),
		$q->param('nickname'), 
		$q->param('team')) if ($q->param('name') ne "" && $q->param('nickname') ne "" && $q->param('team') ne "");
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
		$q->param('nickname'), 
		$q->param('team')) if ($q->param('name') ne "" && $q->param('nickname') ne "" && $q->param('team') ne "");
	dbmclose (%hash);
	$q->delete_all();
	}
	
	sub show 
	{
		print $q->h1("Список участников соревнований");
		print $q->start_form;
		print $q->table(
			$q->Tr("Заполните форму:"),
			$q->Tr(
				$q->td($q->textfield(-name => "name",-placeholder => "Имя участника", -size => 30)),
				$q->td($q->textfield(-name => "nickname",-placeholder => "Никнейм участника", -size => 30)),
				$q->td($q->textfield(-name => "team",-placeholder => "Название команды", -size => 30)),
				$q->td($q->submit(-name=>'action',-value => "Добавить в список"))
			)
		);
		
		print $q->hidden('student',$global->{'student'});
		print $q->end_form;
		
		
		print $q->br;
		print $q->hr;
		print $q->br;
		
		print $q->start_table();
		
		
		print $q->Tr ( 
		$q->th("№"),
		$q->th("Имя участника"),
		$q->th("Никнейм"),
		$q->th("Название команды"),
		$q->th()
		);
		
		dbmopen(my %hash,"mylist",0644) or die;
		foreach my $k (sort keys %hash)
		{
			
			print $q->start_form;
			print $q->hidden(-name => 'item', -value => $k);
			print $q->hidden('student',$global->{'student'});
			
			my @val = split(/::/,$hash{$k});
			
			print $q->Tr ( 
			$q->td($k+1),
			$q->td($q->textfield(-name => "name",-size => 30, -value => $val[0])),
			$q->td($q->textfield(-name => "nickname",-size => 30, -value => $val[1])),
			$q->td($q->textfield(-name => "team",-size => 30, -value => $val[2])),
			$q->td($q->submit(-name=>'action',-value => "Редактировать"),
					$q->submit(-name=>'action',-value => "Удалить"))
			);	
			print $q->end_form;
		}
		if (!%hash) 
		{
			print $q->Tr ($q->td({-colspan => 5}, "Список пуст"));
		}
		dbmclose (%hash);
		
		print $q->end_table;
	}
	

	
	if ($menu{$q->param('action')}) {$menu{$q->param('action')}->();} 

	show();

	print $q->end_html;
}

1;
