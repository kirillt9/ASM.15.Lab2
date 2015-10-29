package ST39;
use strict;

use CGI;
use CGI::Carp qw(fatalsToBrowser);

sub st39
{
	my ($q, $global) = @_;
	my @tracklist = ();


	sub show_interface {
	
		print $q->start_form;
		print $q->hidden(-name => 'student', -value => $global->{'student'});

		print $q->h1({-align => 'center'},'Cписок воспроизведения');
		
		print $q->start_table({-border => 1, -align => 'center',-bgcolor => "#ff8c8c", -bordercolor => "black"});
		print $q->start_Tr;
		print $q->start_td;
		
		print $q->start_table({-border => 1,-height => '100%', -bordercolor => "black"});
		print $q->Tr($q->th('Добавить композицию:')	);

		
		print $q->Tr($q->td({-align=>'center'},
			$q->submit(-name=>'action',-value => "Удалить")));
		
		for( my $i = 0; $i < scalar @tracklist; $i++)
		{
			print $q->Tr($q->td({-align=>'center', -height => 25}, $q->checkbox(-name=>'check', -value=>$i+1, -label=>'')));
		}
		
		print $q->end_table;
		print $q->end_form;
		
		print $q->end_td;
		
		print $q->start_td;
		
		print $q->start_table({-border => 1,-height => '100%',-bgcolor => "black", -bordercolor => "black"});
		
		print $q->start_form;
		print $q->hidden(-name => 'student', -value => $global->{'student'});
		
		print $q->Tr(
		$q->td($q->textfield(-name => "performer", -size => 40, -placeholder => "Введите имя исполнителя")),
		$q->td($q->textfield(-name => "song", -size => 40, -placeholder => "Введите название песни")),
		$q->td($q->submit(-name=>'action',-value => "Отправить"))
		);
		
		print $q->end_form;

		print $q->Tr({-bgcolor => "#ff8c8c"},
		$q->th({-align => 'center'},'Исполнитель'),
		$q->th({-align => 'center'},'Композиция'),
		$q->th()
		);
		
		 for( my $i = 0; $i < scalar @tracklist; $i++)
		{
			print $q->start_form;
			print $q->hidden(-name => 'student', -value => $global->{'student'});
			
			print $q->Tr(
				$q->td({ -height => 25},$q->textfield(-name => "performer", -size => 40, -value => $tracklist[$i]{performer})),
				$q->td({ -height => 25},$q->textfield(-name => "song", -size => 40, -value => $tracklist[$i]{song})),
				$q->td({-align=>'center', -height => 25},$q->submit(-name=>'action',-value => "Изменить"))
			);
			
			print $q->hidden(-name => 'i', -value => $i+1);
			print $q->end_form;
		}
		
		print $q->end_table;
		
		print $q->end_td;
		print $q->end_Tr;
		print $q->end_table;

	};
	
	sub send {
	my $performer = $q->param('performer');
	my $song = $q->param('song');
	my $i = $q->param('i');
	
	if (($performer ne "") && ($song ne "")) {
	if (!$i) {
	push @tracklist, {performer => $performer, song => $song};
	} else {
	$tracklist[$i-1]{performer} = $performer;
	$tracklist[$i-1]{song} = $song;
	}
	}
	print $q->delete('performer','song');
	};

	
	sub delete {
	my @items = $q->param('check');

	my $shift =0 ;
	foreach my $i (@items) {
    splice(@tracklist,$i-1-$shift,1);
	$shift++;
	}
	print $q->delete('check');
	};
	
	
	my $trackfile = "tracklist";
	
	sub load {
	@tracklist = ();

		dbmopen(my %hash,$trackfile,0644) || die "Can't open file!\n";
		foreach my $k (sort keys %hash) {
			my @v = split(/__/,$hash{$k});
			$tracklist[$k]->{performer}=$v[0];
			$tracklist[$k]->{song}=$v[1];}
		dbmclose (%hash);

	};
	
	sub save {
		dbmopen(my %hash,$trackfile,0644) || die "Can't open file!\n";
		%hash = ();
		for (my $i=0;$i<scalar @tracklist;$i++){
			$hash{$i} = join("__",$tracklist[$i]->{performer},$tracklist[$i]->{song}); };
		dbmclose (%hash);
	};
	
	my %menu = ( "Отправить" => \&send, "Изменить" => \&send,"Удалить" => \&delete);
	

	print $q->header(-type => "text/html", -charset => "windows-1251");
	print $q->font({-color=>'black', -face=>'trebuchet ms'});
	print "<a href=\"$global->{selfurl}\">Назад</a>";
	
	print $q->start_html(-title => "Ступин Игорь",  -bgcolor => "#ede0ce");
	
	load;
	
	$menu{$q->param('action')}->() if ($menu{$q->param('action')}); 
	
	show_interface;
	
	save;
	print $q->end_html;
}

1;

