use Test::Most;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::DBIx::Class {
    schema_class => 'OpusVL::SysParams::Schema',
}, 'SysInfo';
use OpusVL::SysParams;

SysInfo->set('test.param', 1);
is SysInfo->get('test.param'), 1;
my @keys = SysInfo->key_names;
eq_or_diff \@keys, [ 'test.param' ];

my $params = OpusVL::SysParams->new({ schema => SysInfo->result_source->schema });

is $params->get('test.param'), 1;

$params->set('test.array', [ 1, 2, 3 ]);
eq_or_diff $params->get('test.array'), [ 1, 2, 3 ];

@keys = $params->key_names;
eq_or_diff \@keys, [ 'test.array', 'test.param' ];

done_testing;
