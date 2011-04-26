package OpusVL::SysParams;

use warnings;
use strict;

use Moose;

has 'schema' => (isa => 'DBIx::Class::Schema', is => 'ro', required => 1 ); # can we set a default?

=head1 NAME

OpusVL::SysParams - Module to handle system wide parameters

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

This module handles system wide parameters.


    use OpusVL::SysParams;

    my $sys_param = OpusVL::SysParams->new({ schema => $schema});
    my $val = $sys_param->get('login.failures');
    $sys_param->set('login.failures', 3);
    ...

=head1 METHODS

=head2 get

Get a system parameter.  The key name is simply a string.  It's suggested you use some 
kind of schema like 'system.key' to prevent name clashes with other unoriginal programmers.

=cut

sub get {
    my $self = shift;
    my $schema = $self->schema;
    return $schema->resultset('SysInfo')->get(@_);
}

=head2 key_names

Returns the keys of the system parameters.

=cut

sub key_names {
    my $self = shift;
    my $schema = $self->schema;
    return $schema->resultset('SysInfo')->key_names(@_);
}

=head2 set

Set a system parameter.  The key name is simply a string.  It's suggested you use some 
kind of schema like 'system.key' to prevent name clashes with other unoriginal programmers.

The value can be any data structure so long as it doesn't contain code.  

=cut

sub set {
    my $self = shift;
    my $schema = $self->schema;
    return $schema->resultset('SysInfo')->set(@_);
}

=head2 set_raw

Set a system parameter.  This is essentially the same as set but it allows you to store a raw json
representation of the variable you want to store.  In order to support complex data structures the
data you 'set' is stored in json.  You probably don't want to use this method.

=cut

sub set_raw {
    my $self = shift;
    my $schema = $self->schema;
    return $schema->resultset('SysInfo')->set_raw(@_);
}

=head1 AUTHOR

OpusVL, C<< <colin at opusvl.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut

1; # End of OpusVL::SysParams
