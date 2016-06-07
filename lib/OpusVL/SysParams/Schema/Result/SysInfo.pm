package OpusVL::SysParams::Schema::Result::SysInfo;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
use JSON;
use Data::Munge qw/elem/;
use Scalar::Util qw/reftype/;
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

=head2 METHODS

=head2 convert_to

=over

=item $data_type

=back

Converts the value to the provided data type (see C<viable_type_conversions>),
if necessary. Returns the decoded value, i.e. a Perl data structure.

=head2 set_type_from_value

=over

=item $value

=back

Attempts to guess the data type of the provided value, which defaults to the
row's value if not provided. Sets the C<data_type> property on the field, but
doesn't save it.

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
    # NOTE: don't set a default value for objects, because the current data_type
    # restricts what other data_types we can select.
      data_type => 'enum',
      is_nullable => 1,
      extra => {
        list => [ qw/text textarea object array bool/ ],
        labels => [ "Text", "Multiline Text", "Object", "List", "Boolean" ],
      }
  },
);
__PACKAGE__->set_primary_key("name");

sub decoded_value
{
    my $self = shift;
    return if not defined $self->value;
	return JSON->new->allow_nonref->decode($self->value);
}

sub viable_type_conversions {
    my $self = shift;

    return $self->column_info('data_type')->{extra}->{list}
        if not $self->data_type;

    my $options = +{
        text => [ qw/textarea array/ ],
        bool => [ qw/text textarea/ ],
        array => [ qw/textarea/ ],
        textarea => [ qw/array/ ],
    }->{$self->data_type} // [];

    unshift @$options, $self->data_type;
    return $options;
}

sub convert_to {
    my $self = shift;
    my ($type) = @_;

    die "Cannot convert " . $self->name . " to $type"
        unless elem $type, $self->viable_type_conversions;

    return $self->decoded_value
        if $type eq $self->data_type;

    my $conv = {
        "text textarea"    => sub { @_ },
        "text array"       => sub { [@_] },
        "bool text"     => sub { $_[0] ? "True" : "False" },
        "bool textarea" => sub { $_[0] ? "True" : "False" },
        "array textarea"   => sub { join "\n", @{$_[0]} },
        "textarea array"   => sub { [ split /\n/, $_[0] ] },
    };

    my $key = join ' ', $self->data_type, $type; 

    $conv->{$key}->($self->decoded_value);
}

sub set_type_from_value {
    my $self = shift;
    my $value = shift // $self->decoded_value;

    if (ref $value) {
        if (ref $value =~ /Bool/) {
            # JSON::Boolean, JSON::PP::Boolean, etc
            $self->data_type('bool')
        }
        elsif (reftype $value eq 'HASH') {
            $self->data_type('object');
        }
        elsif (reftype $value eq 'ARRAY') {
            $self->data_type('array');
        }
        else {
            warn "Cannot determine type for " . $self->name . " given " . reftype $value . ".";
        }
    }
    else {
        if ($value =~ /\n/) {
            $self->data_type('textarea');
        }
        else {
            $self->data_type('text');
        }
    }
}

__PACKAGE__->meta->make_immutable;

1;

