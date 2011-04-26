use Test::Most;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::DBIx::Class {
    schema_class => 'OpusVL::SysParams::Schema',
}, 'SysInfo';
use OpusVL::SysParams;

SysInfo->set('test.param', 1);
is SysInfo->get('test.param'), 1;

my $params = OpusVL::SysParams->new({ schema => SysInfo->result_source->schema });

is $params->get('test.param'), 1;

done_testing;
