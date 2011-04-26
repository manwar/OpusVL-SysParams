package OpusVL::SysParams::Schema::ResultSet::SysInfo;

use Moose;
extends 'DBIx::Class::ResultSet';
use JSON;

=head1 NAME

OpusVL::SysParams::Schema::ResultSet::SysInfo

=head1 SYNOPSIS

This is the ResultSet that actually stores and gets results from DBIx::Class.

    $schema->resultset('SysInfo')->set('test.param', 1);
    $schema->resultset('SysInfo')->get('test.param');

This is used by the L<OpusVL::SysParams> object.

=head1 METHODS

=head2 get

Get a system parameter.  The key name is simply a string.  It's suggested you use some 
kind of schema like 'system.key' to prevent name clashes with other unoriginal programmers.

=head2 set

Set a system parameter.  The key name is simply a string.  It's suggested you use some 
kind of schema like 'system.key' to prevent name clashes with other unoriginal programmers.

The value can be any data structure so long as it doesn't contain code.  

=head2 set_raw

Set a system parameter.  This is essentially the same as set but it allows you to store a raw json
representation of the variable you want to store.  In order to support complex data structures the
data you 'set' is stored in json.  You probably don't want to use this method.

=head2 key_names

Returns the keys of the system parameters.


=head1 AUTHOR

OpusVL, C<< <colin at opusvl.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut
sub set
{
    my ($self, $name, $value) = @_;
    
    return $self->set_raw($name, JSON->new->allow_nonref->encode($value));
}

sub set_raw
{
	my $self  = shift;
	my $name  = shift;
	my $value = shift;

	my $info = $self->update_or_create
	({
		name  => $name,
		value => $value
	});

	return $value;
}

sub get 
{
	my $self = shift;
	my $name = shift;

	my $info = $self->find
	({
		name => $name
	});

	return $info ? JSON->new->allow_nonref->decode($info->value) : undef;
}

sub key_names
{
    my $self = shift;

    return $self->search(undef, { order_by => 'name' })->get_column('name')->all;
}

1;
