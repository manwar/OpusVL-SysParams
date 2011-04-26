use inc::Module::Install;

name     'OpusVL-SysParams';
all_from 'lib/OpusVL/SysParams.pm';
author   q{OpusVL <colin@opusvl.com>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

