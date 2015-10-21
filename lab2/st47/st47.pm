#!perl.exe

package ST47;
use strict;
use CGI;
use Scalar::Util qw(looks_like_number);

sub st47 {
	my ($page, $global) = @_;

	my @MainList = ();

	sub add {
		my $cname = $page->param('cname');	
		my $ctown = $page->param('ctown');
		if ( ( $cname ne "" ) && ( $ctown ne "") ){
			my $file = ("database");	
			my %h;
			dbmopen(%h, $file, 0644);
			my $size = scalar keys %h;
			$h{$size} = join('--', $cname, $ctown);		
			dbmclose(%h);
		}
	};
	sub edit {
		my $cname = $page->param('cname');	
		my $ctown = $page->param('ctown');
		my $number = $page->param('number');
		if ( ( $cname ne "" ) && ( $ctown ne "") ){
			my $file = ("database");	
			my %h;
			dbmopen(%h, $file, 0644);
			$h{$number} = join('--', $cname, $ctown);
			dbmclose(%h);
		}	
	}
	sub delete {
		my $number = $page->param('number');
		my $file = ("database");	
		my %h;
		dbmopen(%h, $file, 0644);
		my @RedactList = ();
		for (my $i = 0; ; $i++){
			if (exists $h{$i}){
				if ($i != $number){
					push @RedactList, $h{$i};
				}
			} else {
				last;
			}		
		}
		undef %h;
		for (my $i = 0;  $i < scalar @RedactList; $i++){
			$h{$i} = $RedactList[$i];
		}	
		dbmclose(%h);
	}
	my @functions = (
		\&add,
		\&edit,
		\&delete
	);

	if (looks_like_number($page->param('action'))){
		$functions[$page->param('action')]();
	}

	sub load {
		my $file = ( "database" );	
		my %h;
		dbmopen(%h, $file, 0644);
		for (my $i = 0; ; $i++){
			if (exists $h{$i}){
				my ($cname, $ctown) = split(/--/, $h{$i});
				push @MainList, {cname => $cname, ctown => $ctown};
			} else {
				last;
			}		
		}
		dbmclose(%h);
	};
	sub show_page {
		print '
			<table width="100%" border=0>
				<tr>
					<td colspan=5 style="font-size:30px; text-align: center;">
						СПИСОК КОМПАНИЙ
					</td>
				</tr>
			<tr>
				<td  style="font-size:16px; text-align: center;">
					<b>
					№
					</b>
				</td>
				<td  style="font-size:16px; text-align: center;">
					<b>
						Название Компании
					</b>
				</td>
				<td  style="font-size:16px; text-align: center;">
					<b>
						Город
					</b>
				</td>
				<td  colspan=2 style="font-size:16px; text-align: center;">
					<b>
						Действия
					</b>
				</td>
			</tr>';	
		print $page->start_form();
		print '
			<tr>
				<td  style="font-size:16px; text-align: center;">
					<b>';
		print $page->hidden('student',$global->{'student'});
		print '			</b>
				</td>
				<td  style="font-size:16px; text-align: center;">
					<b>';
		print $page->textfield('сname',"",30,100);
		print '
					</b>
				</td>
				<td  style="font-size:16px; text-align: center;">
					<b>';
		print $page->textfield('сtown',"",30,100);		
		print '
					</b>
				</td>
				<td  colspan=2 style="font-size:16px; text-align: center;">
					<b>
					<button name="action" value=0 type="submit">Добавить</button>
					</b>
				</td>
			</tr>';	
		print $page->end_form;		
		if (scalar @MainList == 0){
			print '<tr>
					<td colspan=5 style="font-size:24px; text-align: center;">
						<b>Список пуст</b>
					</td>
				</tr>';	
		} else {
			for (my $i = 0; $i < scalar @MainList; $i++) {
				print $page->start_form();
				print '
					<tr>
						<td  style="font-size:16px; text-align: center;">
							<b>';
				print $page->hidden('number',$i);
				print $page->hidden('student',$global->{'student'});
				print $i+1;
				print '
							</b>
						</td>
						<td  style="font-size:16px; text-align: center;">
							<b>';
				print $page->textfield('сname',$MainList[$i]->{'ctown'},30,100);
				print '
							</b>
						</td>
						<td  style="font-size:16px; text-align: center;">
							<b>';
				print $page->textfield('ctown',$MainList[$i]->{'ctown'},30,100);		
				print '
							</b>
						</td>
						<td  style="font-size:16px; text-align: center;">
							<b>
							<button name="action" value=1 type="submit">Редактировать</button>
							</b>
						</td>
						<td  style="font-size:16px; text-align: center;">
							<b>
							<button name="action" value=2 type="submit">Удалить</button>
							</b>
						</td>
					</tr>';	
				print $page->end_form;
			}	
		}
		print '
			</table>
			<a href="'.$global->{'selfurl'}.'"><<Назад</button>';		
	}

	print $page->header( -type => "text/html", -charset => "windows-1251");
	print $page->start_html( -title => "Утенов Р.А." );
	print $page->delete_all();
	load;
	show_page;
	print $page->end_html;
}

return 1;
