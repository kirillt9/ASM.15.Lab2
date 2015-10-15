package ST26;

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use lab2::st26::Person;

sub st26
{
    my ($q, $global) = @_;
    my $filename = "st26db";
    my @group;  
    my %actions = (
       'add' => \&add,
       'do_edit' => \&do_edit,
       'delete' =>\&del
    );

    #save students to dbm file function 
    sub save { 
       if(@group>0)
        {
            dbmopen(my %data, $filename, 0644) or die "Cant open $filename file\n";
            %data = ();
            my $count = 0;
            for (@group) { 
                $data{++$count} =$_->getPerson() ;
            }     
            dbmclose(%data);
        }
    };

    #load students from dbm file function 
    sub load{ 
        undef(@group);
        dbmopen(my %data, $filename, 0644) or die "Cant open $filename file\n";  
        foreach my $key ( keys %data ) {
            (my $f, my $l,my $id )= split(/::@::/,$data{$key});
             push(@group,Person->new($f, $l, $id));
        }
        dbmclose(%data);
    };

    #add student function 
    sub add {
        my $f_name = $q->param('f_name');
        my $l_name = $q->param('l_name');
        my $id = $q->param('id');
        push(@group,Person->new($f_name, $l_name, $id));
    };

    #edit student function 
    sub do_edit{
        my $num =  $q->param('idd');
        $group[$num-1]->setFirstName($q->param('f_name'));
        $group[$num-1]->setLastName($q->param('l_name'));
        $group[$num-1]->setID($q->param('id'));
    };

    #delete_student function 
    sub del{
         my $num =  $q->param('idd');
         splice @group,$num-1,1;
    };

    #print add/edit form function 
    sub show_form{   
        my $f_name = "";
        my $l_name = "";
        my $id = "";
        my $btn_tex = "add";
        my $n =  $q->param('idd');
        if ($q->param('action') eq 'edit')
        {
            print "<h3> Edit Student Form </h3>";
            $btn_tex = "do_edit";
           
            if(defined  $group[$n-1])
            {
                $f_name = $group[$n-1]->getFirstName();
                $l_name = $group[$n-1]->getLastName();
                $id = $group[$n-1]->getID();
            }
            
        }
        else
        {
            print "<h3> Add Student Form </h3>";
        }

        print $q->start_table;
        print $q->start_form( -method  => 'POST');
        print "<input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">";
        print $q->Tr(
                $q->td('First Name:'),
                $q->td("<input type=\"text\" name=\"f_name\" value=\"$f_name\">"));
        print $q->Tr(
                $q->td('Last Name:'),
                $q->td("<input type=\"text\" name=\"l_name\" value=\"$l_name\">"));
        print $q->Tr(
               $q->td('ID:'),
               $q->td("<input type=\"text\" name=\"id\" value=\"$id\">"));
        print $q->Tr(
              $q->td( $q->submit(-name=> 'action',-value => "$btn_tex")
              ));
        print  "<input type=\"hidden\" name=\"idd\" value=\"$n\">";
        print $q->end_form;
        print $q->end_table;
    };

    #print students function 
    sub show_group{
        print "<h1> Student's group </h1>";    
        print $q->start_table;
        print "<tr>
                    <th>-Number-</th>
                    <th>-FirstName-</th>
                    <th>-LastName-</th>
                    <th>-ID-</th>
                </tr>";

        my $count = 0;
        foreach (@group) { 
            ++$count;
            my $n = $_->getFirstName();
            my $l = $_->getLastName();
            my $idd = $_->getID();
            print $q->Tr(
                    $q->start_form(-method  => 'POST').
                    "<input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
                    <input type=\"hidden\" name=\"idd\" value=\"$count\">".
                     $q->td([$count,$_->getFirstName(), 
                                    $_->getLastName() ,
                                    $_->getID(), 
                                    $q->submit(-name=> 'action',-value => 'edit'),
                                    $q->submit(-name=> 'action',-value => 'delete')]).
                     $q->end_form()
                    );
        }     
        print $q->end_table;
        print "<hr>";
    };
  
    load();
    print $q->header();
    if(defined $actions{$q->param('action')} )
    {
        $actions{$q->param('action')}->();       
    }
    show_group();
    show_form();  
    print "<a href=\"$global->{selfurl}\">Back</a>";
    save(); 
}
return 1;