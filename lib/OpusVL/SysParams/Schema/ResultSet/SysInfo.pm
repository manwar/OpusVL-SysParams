package OpusVL::SysParams::Schema::ResultSet::SysInfo;

use Moose;
extends 'DBIx::Class::ResultSet';

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
