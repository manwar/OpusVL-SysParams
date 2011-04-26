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

=cut

sub get {
    my $self = shift;
    my $schema = $self->schema;
    return $schema->resultset('SysInfo')->get(@_);
}

=head2 set

=cut

sub set {
    my $self = shift;
    my $schema = $self->schema;
    return $schema->resultset('SysInfo')->set(@_);
}

=head1 AUTHOR

OpusVL, C<< <colin at opusvl.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut

1; # End of OpusVL::SysParams
