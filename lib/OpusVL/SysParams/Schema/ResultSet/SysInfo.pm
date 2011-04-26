package OpusVL::SysParams::Schema::ResultSet::SysInfo;

use Moose;
extends 'DBIx::Class::ResultSet';

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

=head1 AUTHOR

OpusVL, C<< <colin at opusvl.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut
sub set
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

	return $info ? $info->value : undef;
}



1;
