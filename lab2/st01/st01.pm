package ST01;

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);


sub st01
{
my ($q, $global) = @_;
my $filename = "st01_lib";
my @library;
my $add_edit = "Добавить";

sub show_form
{
	print $q->start_form(-method => "post");
	print $q->hidden('student',$global->{'student'});
	print 'Содержимое библиотеки сохраняется в файл с именем '."$filename".'.';
 	
	my $n = undef;
	if ($q->param('number'))
	{
		$n = $q->param('number')-1;
		print $q->h3("Изменить запись о книге №".($n+1));
	}
	else
	{
		print $q->h3("Добавить запись о книге");
	}
	print $q->hidden('edit_number',$n);

	print $q->start_table;
	
		print $q->Tr(
		$q->td('Введите название книги:'),
		$q->td($q->textfield(-name => "name", -size => 40))
		);

		print $q->Tr(
		$q->td('Введите фамилию автора:'),
		$q->td($q->textfield(-name => "author", -size => 40))
		);
	
		print $q->Tr(
		$q->td('Введите год издания:'),
		$q->td($q->textfield(-name => "year", -size => 40))
		);
	
		print $q->Tr(
		$q->td('<br>',$q->submit(-name=>'action',-value => "$add_edit")));
	
	print $q->end_table;
	print $q->end_form;
};

sub check_input
{
	my ($in) = @_;
	$in =~ /^$/ ? return 0: return 1;
};
	
sub add 
{
	my $name = $q->param('name');
	my $author = $q->param('author');
	my $year = $q->param('year');	
	
	return if (check_input($name)+check_input($author)+check_input($year)<3);

	my $new_record = {Name => $name, Author => $author, Year => $year};
	push @library,$new_record;
};

sub from_file
{
	if (!(-e "$filename.pag"))
	{	
		@library = ();
		return;
	}

	dbmopen(my %dbm_hash,$filename,0666) || die;
	my $i = 0;
	while ( (my $k,my $v) = each %dbm_hash) 
	{
		my @values = split(/::/,$v);
		$library[$i]{Name}=$values[0];
		$library[$i]{Author}=$values[1];
		$library[$i]{Year}=$values[2];
		$i++;
	}
	dbmclose (%dbm_hash);
};
	
sub to_file
{
	my $n_records = @library;
	unlink("$filename.pag");
	unlink("$filename.dir");
	return if ($n_records == 0);
	
	dbmopen(my %dbm_hash,$filename,0666) || die;
	%dbm_hash = ();
	for (my $i=0; $i<$n_records; $i++)
	{
		$dbm_hash{$i} = join("::",$library[$i]{Name},$library[$i]{Author}, $library[$i]{Year});
	}
	dbmclose (%dbm_hash);
};	

sub show_table
{
	print $q->start_table({-border => 1});

	print $q->Tr(
	$q->th(),
	$q->th({-align => "center"},"№"),
	$q->th({-align => "center"},"Название книги"),
	$q->th({-align => "center"},"Автор"),
	$q->th({-align => "center"},"Год издания")
	);
	
	my $n_records = @library;
	if ($n_records != 0)
	{
	for (my $i=0; $i<$n_records; $i++)
	{
		print $q->start_form(-method => "post");
		print $q->hidden('student',$global->{'student'});
		print $q->hidden(-name=>'number', -value=>$i+1 );
		print $q->Tr(
		$q->td($q->submit(-name=>'action',-value => "Редактировать"),
		$q->submit(-name=>'action',-value => "Удалить")),
		$q->td({-align => "center"},$i+1),
		$q->td({-align => "center"},$library[$i]{Name}),
		$q->td({-align => "center"},$library[$i]{Author}),
		$q->td({-align => "center"},$library[$i]{Year})
		);
		print $q->end_form;
	}
	}

	print $q->end_table;
};
	
sub delete
{
	my $number = $q->param('number')-1;
	splice(@library,$number,1);
	print $q->delete_all();
}	

sub pre_edit
{
	my $number = $q->param('number')-1;
	$q->param(-name=>'name',-value=>$library[$number]{Name});
	$q->param(-name=>'author',-value=>$library[$number]{Author});
	$q->param(-name=>'year',-value=>$library[$number]{Year});
	$add_edit = "Изменить";
};

sub edit
{
	my $number = $q->param('edit_number');
	$library[$number]{Name} = $q->param('name');
	$library[$number]{Author} = $q->param('author');
	$library[$number]{Year} = $q->param('year');
	print $q->delete_all();
}
	
my %menu = (
	"Добавить" => \&add,
	"Редактировать" => \&pre_edit,
	"Изменить" => \&edit,
	"Удалить" => \&delete
);	

print $q->header(-type => "text/html", -charset => "windows-1251", );
print $q->start_html(-title => "Багликова Ю. АСМ-15-04",  -bgcolor => "DAE8B5");
print "<a href=\"$global->{selfurl}\">Назад к выбору программы</a>";
print $q->h1("Библиотека");

from_file();

if ($menu{$q->param('action')}) 
{
	$menu{$q->param('action')}->();     
}

show_form();
print $q->hr;  
print $q->delete_all();
show_table();
to_file();
print $q->end_html;

}

return 1;
