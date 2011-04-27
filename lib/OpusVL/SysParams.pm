package OpusVL::SysParams;

use warnings;
use strict;
use JSON;

use Moose;

has 'schema' => (isa => 'DBIx::Class::Schema', is => 'ro', required => 1,
    default => sub
    {
        # this means we only load Config::JFDI and create our schema if they
        # don't specify their own schema.
        require Config::JFDI;
        require OpusVL::SysParams::Schema;
        my $config = Config::JFDI->new(name => __PACKAGE__);
        my $config_hash = $config->get;
        my $schema = OpusVL::SysParams::Schema->connect( @{$config_hash->{'Model::SysParams'}->{connect_info}} );
        return $schema;
    }
); 

=head1 NAME

OpusVL::SysParams - Module to handle system wide parameters

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

This module handles system wide parameters.


    use OpusVL::SysParams;

    my $sys_param = OpusVL::SysParams->new();

    # or 

    my $sys_param = OpusVL::SysParams->new({ schema => $schema});

    my $val = $sys_param->get('login.failures');
    $sys_param->set('login.failures', 3);
    ...

=head1 METHODS

=head2 new

If the constructor is called without a schema specified it will attempt to load up a schema based
on a config file in the catalyst style for the name 'OpusVL::SysParams'.  This config file should
have a Model::SysParams section containing the config.

    <Model::SysParams>
        connect_info dbi:Pg:dbname=test1
        connect_info user
        connect_info password
    </Model::SysParams>

Note that you must specify at least 2 connect_info parameters even if you are using SQLite otherwise
the code will crash.

=head2 get

Get a system parameter.  The key name is simply a string.  It's suggested you use some 
kind of schema like 'system.key' to prevent name clashes with other unoriginal programmers.

=cut

sub get {
    my $self = shift;
    my $schema = $self->schema;
    return $schema->resultset('SysInfo')->get(@_);
}

=head2 del

Delete a system parameter.  The key name is simply a string.  
=cut

sub del {
    my $self = shift;
    my $schema = $self->schema;
    return $schema->resultset('SysInfo')->del(@_);
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

=head2 set_json

Set a system parameter.  This allows you to pass the object encoded as JSON in order to make it simpler
for web interfaces to talk to the settings.

=cut

sub set_json {
    my $self = shift;
    my $name = shift;
    my $val = shift;
    my $schema = $self->schema;
    my $obj = JSON->new->allow_nonref->decode($val);
    return $schema->resultset('SysInfo')->set($name, $obj);
}

=head2 get_json

Returns the value encoded in json.  Primarily for talking with web interfaces.

=cut

sub get_json {
    my $self = shift;
    my $schema = $self->schema;

    my $val = $schema->resultset('SysInfo')->get(@_);
    return if !$val;
    return JSON->new->allow_nonref->encode($val);
}

=head1 AUTHOR

OpusVL, C<< <colin at opusvl.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut

1; # End of OpusVL::SysParams
