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

=head2 list

List all parameters. If passed a true value as its first argument, the list will
be a nested hashref of the form

    {
        path => 'path.to.node',
        value => 'node value',
        comment => '...',
        children => {
            childnode => {
                path => 'path.to.node.childnode',
                ...
            }
        }
    }

The topmost node will have no path, comment, or value, only children. Inner
nodes will always have a path, but may have no value or no children (nodes with
no children should always have a value).

If the true parameter is not passed, this simply returns a default ResultSet for
all parameters in the table.

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

=head1 AUTHOR

OpusVL, C<< <colin at opusvl.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut

sub list {
    my $self = shift;
    my $group = shift;

    my $rs = $self->search;
    return $rs if not $group;

    # TODO: should be able to write a WITH RECURSIVE query to get an RS here
    # instead. That means the return value would always be the same.
    my $groups = {};

    for my $setting ($rs->all) {
        my @path = split /\./, $setting->name;
        my $node = $groups;

        while (@path) {
            my $name = shift @path;
            my $path = $node->{path} || '';
            $node->{children}->{$name} //= {};

            $node = $node->{children}->{$name};
            $node->{path} ||= join '.', grep {$_} $path, $name;
        }

        $node->{value}   = $setting->raw_value;
        $node->{comment} = $setting->comment;
    }

    return $groups;
}

sub set
{
	my $self  = shift;
	my $name  = shift;
	my $value = shift;

	my $info = $self->update_or_create
	({
		name  => $name,
		value => $value,
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

    return undef if not $info;

    return $info->value;
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
