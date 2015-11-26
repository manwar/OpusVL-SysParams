use inc::Module::Install;

name     'OpusVL-SysParams';
all_from 'lib/OpusVL/SysParams.pm';
author   q{OpusVL <colin@opusvl.com>};
license  'perl';

requires 'JSON';
requires 'JSON::MaybeXS';
requires 'DBIx::Class::InflateColumn::Serializer::JSON';
requires 'Moose';
requires 'Moose::Role';
requires 'MooseX::NonMoose';
requires 'Config::JFDI';
requires 'DBIx::Class';
requires 'namespace::autoclean';
requires 'SQL::Translator' => '0.11018';
requires 'Data::Munge';

build_requires 'Test::Most';
build_requires 'Test::DBIx::Class';

auto_install;
resources (
    repository => {
        url => 'ssh://git.rug-01.opusvl.net/srv/git/OpusVL-SysParams',
        type => 'git',
    },
);


WriteAll;

