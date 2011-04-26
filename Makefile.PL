use inc::Module::Install;

name     'OpusVL-SysParams';
all_from 'lib/OpusVL/SysParams.pm';
author   q{OpusVL <colin@opusvl.com>};
license  'perl';

requires 'JSON';
requires 'Moose';
requires 'Moose::Role';
requires 'MooseX::NonMoose';
requires 'namespace::autoclean';

build_requires 'Test::Most';

auto_install;

WriteAll;

