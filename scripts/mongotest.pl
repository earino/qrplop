#!/usr/bin/env perl

use warnings;
use strict;
use Data::Dump qw/dump/;

use FindBin;
use MongoDB;
use MongoDB::OID;

use YAML qw/LoadFile/;

my $config = LoadFile("$FindBin::Bin/../etc/mongo.yml");

my $connection = MongoDB::Connection->new(host => $config->{'host'},
				 	  db_name => $config->{'database'},
					  username => $config->{'username'},
					  password => $config->{'password'});
my $db_name = $config->{'database'};
my $database   = $connection->$db_name;
my $collection = $database->anonymous;
my $id         = $collection->insert({ some => 'data' });
my $data       = $collection->find_one({ _id => $id });
