#!D:/ProgrammFiles/perl/bin/perl.exe
use strict;
use CGI::Carp qw (fatalsToBrowser);
use CGI qw(param);

sub st19{

my @box=();
my $elemnumber=0;


my ($q, $global) = @_;
  my %buffer;


my @funcs= (
  \&add,         
  \&edit,
  \&delete_elem,
  \&showbox,    
  \&saveinfile,
  \&loadfromfile,
  \&actionform
  );
  $funcs[5]->();
  $funcs[3]->();
  $funcs[6]->();

sub add{
            my %nameage= ( name => $_[0], age =>$_[1]);
            push(@box, \%nameage);
            $elemnumber++;
            return 1;
  } 
sub edit{
 
  
   $box[$_[0]]=( name => $_[1], age =>$_[2]);
   
   
   return 1;
 } 
sub showbox{
  
                   printf("Content-type: text/html\n\n");
                   print "<html> <head>
                    <META charset=\"windows-1251\">
                    <title>All Box</title>
                    </head>
                    <body><h1>All box</h1><hr>";
       
            for(my $i = 0; $i < $elemnumber; $i++)
                {
                   my $elemnum = $i+1;
                   my $elem=$i;
                
                    print "    
                    <p><b>Human # $elemnum:</b>
                    <p>Name: <b>${$box[$i]}{name}</b>
                    Age: <b>${$box[$i]}{age}</b><p>
                    <form method=\"post\">
                    <input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
                    <input type=\"hidden\" name=\"elemnumber\" value=\"$elem\">
                    <button name=\"action\" type=\"submit\" value=\"edit_elem\">Edit</button>
                    <button name=\"action\" type=\"submit\" value=\"delete_elem\">Delete</button>
                    </form>
                    <hr  size=\"5\"  color=\"#DCDCDC\" noshade>

      </body>
    </html>";
       }   
    }
sub delete_elem{
   splice(@box,$_[0],1);
   $elemnumber--;
   return 1;
 } 
sub actionform
  {

   
    my $action = "add_elem";
    my $title = "Add human";
    my $elemnum=0;
    my $hidden_param = "";
    my $name = "";
    my $age = "";
    if($q->param("action") eq "edit_elem") 
    {
      
      $elemnum = $q->param("elemnumber");
      $name=$box[$elemnum]->{name};
      $age =$box[$elemnum]->{age};
      $action = "edit_elem";
      $title = "Edit human";
       print "redaktiruyu1 "
     
       }
       
              print "<hr><form method=\"post\">
              <p><h2>$title</h2></p>
              $hidden_param
              <input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
              <p>Name<input type=\"text\" name=\"namein\" value=\"$name\"></p>
              <p>Age<input type=\"text\" name=\"agein\"  value=\"$age\"></p>
              <p><button name=\"action\" type=\"submit\" value=\"$action\">Accept</button></p>
              </form>";
             
       if($q->param("namein")&&$q->param("agein")){
          if($q->param("action") eq "edit_elem") 
            {
               $funcs[1]->( $elemnum , $name, $age);
               $funcs[4]->();
                  print "redaktiruyu2 "
            } 

          if($q->param("action") eq "add_elem") 
            {
               $name=$q->param("namein");
               $age =$q->param("agein");
               $funcs[0]->($name,$age);
               $funcs[4]->();
                 print "dobavlayu "
            }
          }
        if($q->param("action") eq "delete_elem") 
            {
               my $elemnum = $q->param("elemnumber");
               $funcs[2]->($elemnum);
               $funcs[4]->();
               print "udalayu "
             }
             #else{ print "nichego ne nazhato "}

       
       
  print " Kolvo elemnumber".$elemnumber;
  }
sub saveinfile{
         if (@box>0){
         my $i=0;
         my %buf=();
         dbmopen (%buf, "file", 0644) or die print "cant open file";
         foreach my $nameage(@box)
              {
                
                  $buf{$i} = join('--', $nameage->{name}, $nameage-> {age});
                  ++$i;
              }

        dbmclose(%buf);
     }
           else {print "Box is empty";}
           return 1;
  }
  sub loadfromfile{
    
         my %buf;
         dbmopen(%buf, "file", 0777);
         @box = ();
            while ( (my $key, my $value) = each %buf )
           {
             my ($name, $age) = split(/--/, $value);
             my %nameage = (name => $name,age => $age);
             push(@box, \%nameage);
             $elemnumber++;
           }
         dbmclose(%buf);
     return 1;
  }

}

