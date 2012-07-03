package qrplop::plop 1.0 {
	use Moose;
	use MooseX::Method::Signatures;
	
	has 's3_value' => (
		is => 'rw',
	);
	
	has 'oid' => (
		is => 'rw',
	);
};

1;