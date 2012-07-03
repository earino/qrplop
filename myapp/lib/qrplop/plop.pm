package qrplop::plop 1.0 {
	use Moose;
	use YAML qw/LoadFile/;
	use FindBin;
	use MongoDB::Connection;
	use MongoDB::OID;
	
	sub BUILD {
		my $config = LoadFile("$FindBin::Bin/../../etc/mongo.yml");

		my $connection = MongoDB::Connection->new(host => $config->{'host'},
						 	  db_name => $config->{'database'},
							  username => $config->{'username'},
							  password => $config->{'password'});
		my $db_name = $config->{'database'};
		my $database   = $connection->$db_name;
		my $collection = $database->anonymous;
	}
	
	no Moose;
	__PACKAGE__->meta->make_immutable;
};

1;