package OpusVL::SysParams::Schema::Result::SysInfo;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
use JSON;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

=head1 NAME

OpusVL::SysParams::Schema::Result::SysInfo

=cut

__PACKAGE__->table("sys_info");

=head1 ACCESSORS

=head2 name

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 value

  data_type: 'text'
  is_nullable: 1
  original: {data_type => "varchar"}

=head2 comment

  data_type: 'text'
  is_nullable: 1
  original: {data_type => "varchar"}

=head2 decoded_value

Returns the value that the get method returns.  
This may be any arbitrary data (simple) type.

=cut

__PACKAGE__->add_columns(
  "name",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "label",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "value",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "comment",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  data_type =>
  {
      data_type => 'varchar',
      is_nullable => 1,
  },
);
__PACKAGE__->set_primary_key("name");

sub decoded_value
{
    my $self = shift;
	return JSON->new->allow_nonref->decode($self->value);
}


__PACKAGE__->meta->make_immutable;

1;

