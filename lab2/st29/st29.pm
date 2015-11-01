#!/usr/bin/perl

package ST29;
use strict;
use CGI;

my @spisok;

sub st29
{
	my ($q, $global) = @_;
	&printHeader($q, $global);
	my %menu = (
			'add' => \&DoAdd,
 			'doedit' => \&DoEdit,
			'dodelete' => \&DoDelete
	);
    	if($q->param('button') =~ /dorep/){
    		$menu{'doedit'}->($q, $global);
    	}
    	else{
	    	if($q->param('button') =~ /dodelete/){
				$menu{'dodelete'}->($q, $global);
	    	}
	    	else{if(defined $menu{$q->param('button')} ){
				$menu{$q->param('button')}->($q, $global);
	    	}
	    	}
	    
	               
    }
	&Showform($q, $global);
	&printFooter($q, $global);
	print "<a href=\"$global->{selfurl}\">Назад</a>";
};

sub DoLoad{
 	my %A;
    my $i = -1;
    @spisok = ();
    dbmopen(%A, "file", 0666) or die "can't fight this love";
    while ( my ($key, $value) = each(%A) ) {
        my ($id, $name, $age) = split('::::', $value);
        my %rec = (
        		id => $id,
                name => $name,
                age => $age
                
            );
            push(@spisok, \%rec);
        }

        dbmclose(%A);
};

sub DoSave{
	my @aa = @_;
	 my %A;
     my $i = -1;
     my $l = -1;
     dbmopen(%A, "file", 0666);
     %A = ();
     foreach my $pers (@aa){
        $A{++$i} = join('::::',++$l, $pers -> {name}, $pers -> {age});
    }
    dbmclose(%A);
}

sub Showform{

	my ($q, $global) = @_;
	&DoLoad();
	my $lld = $q->param('id');
	if($#spisok == -1){
		print <<ENDHTML;
		<form method = "POST">
		<input hidden="true" name="student" value="$global->{student}">
		<label>ФИО:</label>
		<input type="text" name="fio" placeholder="Введите ФИО" style="margin-left: 50px; margin-bottom: 5px; width: 250px " required> <br>
		<label>Возраст:</label>
		<input type="number" name="age" min="1" max="200" placeholder="Введите возраст" style="margin-left: 30px; margin-bottom: 5px; width: 250px" required> <br>
		<input type="submit" name="button" value="add">
		</form>
ENDHTML
}
	else{
		print <<ENDHTML;
		<form method = "POST">
		<input hidden="true" name="student" value="$global->{student}">
		<table>
                   <tr>
                   <th>Индекс</th>
                   <th>ФИО</th>
                   <th>Возраст</th>
                   <th></th>
                   <th></th>
                   </tr>
ENDHTML
	
	 foreach my $pers (@spisok) {
	 			my $k = $pers->{id};
	 			$k++;
	 			print <<ENDHTML;
                   <tr>
                   <input type="hidden" name="id" value="$pers->{id}">                   
                   <td>$k</td>
                   <td>$pers->{name}</td>
                   <td>$pers->{age}</td>

                   <td><button type="submit" name="button" value="edit$pers->{id}">Edit</button></td>
                   <td><button type="submit" name="button" value="dodelete$pers->{id}">Delete</button></td>
                   </tr>
ENDHTML

                }
                print "</table>";
	if ($q->param('button') =~ /edit/){
		my $num = $q->param('button');
		$num=~ s/edit//;
		&DoLoad();
		my $f = @spisok[$num]->{name};
		my $a = @spisok[$num]->{age};
		print <<ENDHTML;	
		<input hidden="true" name="student" value="$global->{student}">
		<label>ФИО:</label>
		<input type="text" name="fio" value="$f" placeholder="Введите ФИО" style="margin-left: 50px; margin-bottom: 5px; width: 250px " > <br>
		<label>Возраст:</label>
		<input type="number" name="age" value="$a" min="1" max="200" placeholder="Введите возраст" style="margin-left: 30px; margin-bottom: 5px; width: 250px" > <br>
		<td><button type="submit" name="button" value="dorep$num">Edit</button></td>
		</form>
ENDHTML
	}
	else{
				
		
		print <<ENDHTML;	
		<label>ФИО:</label>
		<input type="text" name="fio" placeholder="Введите ФИО" style="margin-left: 50px; margin-bottom: 5px; width: 250px " > <br>
		<label>Возраст:</label>
		<input type="number" name="age" min="1" max="200" placeholder="Введите возраст" style="margin-left: 30px; margin-bottom: 5px; width: 250px" > <br>
		<input type="submit" name="button" value="add">
		</form>
ENDHTML
	}}
};

sub DoAdd{
	my ($q, $global) = @_;
	my %A;
	&DoLoad();
    my $i = $#spisok;
    dbmopen(%A, "file", 0666);
		$A{++$i} = join('::::', ++$i, $q->param('fio'), $q->param('age'));
    dbmclose(%A);
    
};

sub DoEdit{
	my ($q, $global) = @_;
	my $num = $q->param('button');
	$num=~ s/dorep//;
	&DoLoad();
	@spisok[$num]->{name} = $q->param('fio');
	@spisok[$num]->{age} = $q->param('age');
	&DoSave(@spisok);
};

sub DoDelete{
	my ($q, $global) = @_;
	my $num = $q->param('button');
	$num=~ s/dodelete//;
	&DoLoad();
	splice(@spisok, $num, 1);
	&DoSave(@spisok);
};

sub printHeader{
	my ($q, $global) = @_;
	print $q->header( -type=>"text/html",
        				-charset=>"UTF-8");
	print <<ENDHTML;
<html>
<head>
<style>
	td,th {border:0px; padding:15px}
	table {padding-bottom:15px}
</style>
<title>
Лабораторная 2
</title>
</head>
<body>
ENDHTML
};

sub printFooter{
	my ($q, $data) = @_;
	print <<ENDHTML;
</body>
</html>
ENDHTML
};

return 1;
