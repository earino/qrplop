package qrplop::plop 1.0 {
	use Moose;
	use MooseX::Method::Signatures;
	use YAML qw/LoadFile/;
	use FindBin;
	use MongoDB::Connection;
	use MongoDB::OID;
	
	use Data::Dump qw/dump/;
	
	has 'mongo' => (
		is => 'rw',
	);
	
	sub BUILD {
		my $self = shift;
		my $config = LoadFile("$FindBin::Bin/../../etc/mongo.yml");

		my $connection = MongoDB::Connection->new(host => $config->{'host'},
						 	  db_name => $config->{'database'},
							  username => $config->{'username'},
							  password => $config->{'password'});
		my $db_name = $config->{'database'};
		my $database   = $connection->$db_name;
		
		$self->mongo($database);
		
		my $collection = $database->anonymous;
	}
	
	sub make {
		my ($self, %keys) = @_;
	
		foreach my $key (keys %keys) {
			print "key $key value ".$keys{$key}."\n";
		}
	}
	
	no Moose;
	__PACKAGE__->meta->make_immutable;
};

1;