package OpusVL::SysParams::RolesFor::Schema;

use Moose::Role;
use OpusVL::SysParams;

requires 'load_namespaces';

=head1 NAME

OpusVL::SysParams::RolesFor::Schema

=head1 SYNOPSIS

This allows for our logging to be inserted into an existing schema and make use of the existing
connection details.  The class actually injects our schema objects into the existing schema and 
adds a 'sys_params' object to the schema.

    # in your schema class.
    with 'OpusVL::SysParams::RolesFor::Schema';
    OpusVL::SysParams::RolesFor::Schema->setup_sysparams(__PACKAGE__);

    # now anywhere that has access to the schema can access the 
    # sys_params object.
    $schema->sys_params->get('param.name'); 

=head1 METHODS

=head2 sys_params

The OpusVL::SysParams object connected via your schema.

=cut

has sys_params => (isa => 'OpusVL::SysParams', is => 'rw', lazy_build => 1);

sub _build_sys_params
{
    my $self = shift;
    return OpusVL::SysParams->new({ schema => $self });
}

# FIXME: point it to our schema stuff.
sub setup_sysparams
{
    my $class = shift;
    my $package = shift;
    $package->load_namespaces(
        result_namespace => '+OpusVL::SysParams::Schema::Result',
        resultset_namespace => '+OpusVL::SysParams::Schema::ResultSet',
    );
}

=head1 AUTHOR

OpusVL, C<< <colin at opusvl.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut

1;

