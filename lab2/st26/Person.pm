package Person;

use strict;
sub new
{
    my $class = shift;
    my $self = {
        _firstName => shift,
        _lastName  => shift,
        _id       => shift,
    };
   
    bless $self, $class;
    return $self;
}


sub setFirstName {
    my ( $self, $firstName ) = @_;
    $self->{_firstName} = $firstName if defined($firstName);
    return $self->{_firstName};
}

sub setLastName {
    my ( $self, $lastName ) = @_;
    $self->{_lastName} = $lastName if defined($lastName);
    return $self->{_lastName};
}

sub setID{
    my ( $self, $id ) = @_;
    $self->{_id} = $id if defined($id);
    return $self->{_id};
}
sub getFirstName {
    my( $self ) = @_;
    return $self->{_firstName};
}

sub getLastName {
    my( $self ) = @_;
    return $self->{_lastName};
}

sub getID {
    my( $self ) = @_;
    return $self->{_id};
}


sub getPerson{
    my( $self ) = @_;
    return $self->{_firstName}."::@::".$self->{_lastName}."::@::".$self->{_id};

}
return 1;