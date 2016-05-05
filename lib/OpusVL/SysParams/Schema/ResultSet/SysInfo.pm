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
    $schema->resultset('SysInfo')->del('test.param');

This is used by the L<OpusVL::SysParams> object.

=head1 METHODS

=head2 get

Get a system parameter.  The key name is simply a string.  It's suggested you use some 
kind of schema like 'system.key' to prevent name clashes with other unoriginal programmers.

=head2 set

Set a system parameter.  The key name is simply a string.  It's suggested you use some 
kind of schema like 'system.key' to prevent name clashes with other unoriginal programmers.

The value can be any data structure so long as it doesn't contain code.  

=head2 del

Delete a system parameter.

=head2 key_names

Returns the keys of the system parameters.

=head2 ordered

Returns a resultset with an ordering applied.

=head1 AUTHOR

OpusVL, C<< <colin at opusvl.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut

sub ordered
{
    my $self = shift;
    my $me = $self->current_source_alias;
    return $self->search(undef, {
        order_by => ["$me.label", "$me.name"],
    });
}



sub set
{
	my $self  = shift;
	my $name  = shift;
	my $value = shift;
    my $data_type = shift;

	my $info = $self->update_or_new
	({
		name  => $name,
		value => JSON->new->allow_nonref->encode($value),
       ($data_type ? data_type => $data_type : ())
	});

    if (! $info->in_storage or ! $info->data_type) {
        $info->set_type_from_value($value);
        $info->update_or_insert;
    }

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

sub del 
{
	my $self = shift;
	my $name = shift;

	my $info = $self->find
	({
		name => $name
	});

	return $info ? $info->delete : undef;
}

sub key_names
{
    my $self = shift;

    return $self->search(undef, { order_by => 'name' })->get_column('name')->all;
}

1;
