package OpusVL::SysParams::Schema::Result::SysInfo;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

use JSON::MaybeXS;

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", 'FilterColumn');

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

=cut

__PACKAGE__->add_columns(
  "name",
  {
    data_type   => "text",
    is_nullable => 0,
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
);
__PACKAGE__->set_primary_key("name");
__PACKAGE__->filter_column('value' => {
    filter_to_storage => sub {
        JSON->new->allow_nonref->encode($_[1]);
    },
    filter_from_storage => sub {
        JSON->new->allow_nonref->decode($_[1]);
    }
});

before update => sub {
    my $self = shift;
    my $params = shift;

    if (my $raw = delete $params->{value_raw}) {
        $params->{value} = JSON->new->allow_nonref->decode($raw);
    }
};

sub raw_value {
    my $self = shift;

    # A bit awkward - we have to convert it into an object so the JSON
    # serialiser can re-encode it.
    if (my $value = shift) {
        $self->value(JSON->new->allow_nonref->decode($value));
    }

    return if not defined $self->value;
    return JSON->new->allow_nonref->encode($self->value);
}

__PACKAGE__->meta->make_immutable;

1;

