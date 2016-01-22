package OpusVL::SysParams::Schema::Result::SysInfo;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
use JSON;
use Data::Munge qw/elem/;
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

=head2 viable_type_conversions

Returns an arrayref of the types we can probably convert this value to. Also
returns the current type.

For a new row, this simply returns the whole set, because we haven't specified
the type yet.

=head2 convert_to

Converts the value to the provided data type (see C<viable_type_conversions>).
If it's already that type, returns the decoded value.

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
      data_type => 'enum',
      is_nullable => 1,
      extra => {
        list => [ qw/text textarea object array boolean/ ],
        labels => [ "Text", "Multiline Text", "Object", "List", "Boolean" ],
      }
  },
);
__PACKAGE__->set_primary_key("name");

sub decoded_value
{
    my $self = shift;
	return JSON->new->allow_nonref->decode($self->value);
}

sub viable_type_conversions {
    my $self = shift;

    return $self->column_info('data_type')->{extra}->{list}
        if not $self->data_type;

    return +{
        text => [ qw/text textarea/ ],
        boolean => [ qw/boolean text textarea/ ],
        array => [ qw/array textarea/ ],
        textarea => [ qw/textarea array/ ],
    }->{$self->data_type} // [];
}

sub convert_to {
    my $self = shift;
    my ($type) = @_;

    die "Cannot convert new row"
        if ! $self->data_type;

    die "Cannot convert to $type"
        unless elem $type, $self->viable_type_conversions;

    return $self->decoded_value
        if $type eq $self->data_type;

    my $conv = {
        "text textarea" => sub { @_ },
        "boolean text" => sub { $_[0] ? "True" : "False" },
        "boolean textarea" => sub { $_[0] ? "True" : "False" },
        "array textarea" => sub { join "\n", @{$_[0]} },
        "textarea array" => sub { [ split /\n/, $_[0] ] },
    };

    my $key = join ' ', $self->data_type, $type; 

    $conv->{$key}->($self->decoded_value);
}

__PACKAGE__->meta->make_immutable;

1;

