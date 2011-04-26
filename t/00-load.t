#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'OpusVL::SysParams' ) || print "Bail out!
";
}

diag( "Testing OpusVL::SysParams $OpusVL::SysParams::VERSION, Perl $], $^X" );
