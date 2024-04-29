#!perl
use strict;
use warnings;
use Test::More;
use File::Temp;
use LMDB_File qw(:flags);

my $dir = File::Temp->newdir('mdbtXXXX', TMPDIR => 1, EXLOCK => 0);

{
  my $path = "$dir/data.mdb";

  tie my %db, LMDB_File => $path, +{flags => MDB_NOSUBDIR | MDB_NOSYNC}
    or Carp::croak "LMDB_File failed: $!";

  is(scalar keys %db, 0, "empty db");

  is(scalar keys %LMDB::Env::Envs, 1, '1 environment open');

  untie %db if $ENV{USE_UNTIE};
}

is(scalar keys %LMDB::Env::Envs, 0, 'No environment open');

done_testing();
