use strict;
use warnings;
use Test::More;
use Net::CouchDB;

use lib 't/lib';
use Test::CouchDB;
setup_tests();
plan tests => 4;

# This file contains tests for Net::CouchDB::DB::delete

# create a database
my $couch = Net::CouchDB->new( $ENV{NET_COUCHDB_URI} );
my $db_name = sprintf "net-couchdb-$$-%d", int( rand 100_000 );
my $db = $couch->create_db($db_name);
isa_ok $db, 'Net::CouchDB::DB', 'new database';

# the database exists before deletion
my ($found) = grep { $_->name eq $db_name } $couch->all_dbs;
isa_ok $found, 'Net::CouchDB::DB', 'before deletion';

# the database is gone after deletion
$db->delete;
($found) = grep { $_->name eq $db_name } $couch->all_dbs;
is $found, undef, 'missing after deletion';

# try to delete again throws an exception
eval { $db->delete };
like $@, qr/database .* does not exist/, 'double delete exception';
