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
	
	sub make(Str :$path) {
		# take the path, hash it, come up with a string value, 10 digits or so
		# store the path with that value as the key, then come up with a qr
		# code for that stupid http://qrplop/10digitvalue, that's really all
		# you freaking have to do, man.
	}
	
	no Moose;
	__PACKAGE__->meta->make_immutable;
};

1;