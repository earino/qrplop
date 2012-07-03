package qrplop::plopper 1.0 {
	use Moose;
	use MooseX::Method::Signatures;
	use YAML qw/LoadFile/;
	use FindBin;
	use MongoDB::Connection;
	use MongoDB::OID;
	use String::Random;
	use Amazon::S3;
	use File::MMagic;
	use Math::Base36 ':all';
	
	use Data::Dump qw/dump/;
	
	use qrplop::plop;
	
	has 'mongo_db' => (
		is => 'rw',
	);
	
	has 'randomizer' => (
		is => 'rw',
	);
	
	has 's3_bucket' => (
		is => 'rw',
	);
	
	has 'identifier_size' => (
		is => 'rw',
	);
	
	sub BUILD {
		my $self = shift;
		my $mongo_config = LoadFile("$FindBin::Bin/../../etc/mongo.yml");
		my $s3_config = LoadFile("$FindBin::Bin/../../etc/s3.yml");

		my $connection = MongoDB::Connection->new(
							host => $mongo_config->{'host'},
							db_name => $mongo_config->{'database'},
							username => $mongo_config->{'username'},
							password => $mongo_config->{'password'});
		
		my $db_name = $mongo_config->{'database'};
		my $database   = $connection->$db_name;
		
		my $s3 = Amazon::S3->new(
		      {   aws_access_key_id     => $s3_config->{'aws_access_key_id'},
		          aws_secret_access_key => $s3_config->{'aws_secret_access_key'},
		          retry                 => 1
		      }
		);
				
		my $bucket = $s3->bucket($s3_config->{'bucket'});
		my $randomizer = String::Random->new();
		$randomizer->{'A'} = [ 'A'..'Z', 'a'..'z' ];
		
		$self->s3_bucket($bucket);
		$self->mongo_db($database);
		$self->randomizer($randomizer);
		$self->identifier_size(10);		
	}
	
	method make(Str :$path) {
		unless (-e $path) {
			die "Unable to create plop, $path doesn't exist.";
		}
		
		my $random_string = $self->randomizer->randpattern("A" x $self->identifier_size);
		while ($self->s3_bucket()->head_key($random_string)) {
			print "Plop already exists at $random_string, trying again...\n";
			$random_string = $self->randomizer->randpattern("A" x $self->identifier_size);
		}
		
		my $mm = new File::MMagic;
		my $mime_type = $mm->checktype_filename($path);
		
		my $successful_store = $self->s3_bucket->add_key_filename(
			$random_string, $path,
			{
				content_type => $mime_type,
				acl_short => 'public-read'
			}
		);
		
		#FIXME - check successful_store and throw an exception
		
		my $id = $self->mongo_db->plops->insert({
			plop_key => $random_string,
		},{
			safe => 1,
		});
	
		my $plop = qrplop::plop->new(s3_value => $random_string, oid => $id);
		return $plop;
	}
	
	method get(Str :$id) {
		my $retval = undef;
		
		my $record = $self->mongo_db->plops->find_one({_id => MongoDB::OID->new(value => $id)});
		if (defined $record) {
			$retval = $record->{'plop_key'};
		}
		
		return $retval;
	}
	
	no Moose;
	__PACKAGE__->meta->make_immutable;
};

1;