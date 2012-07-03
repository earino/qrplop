use Test::More;   # see done_testing()

use Data::Dump qw/ dump /;

BEGIN { use_ok( 'qrplop::plop' ); }
require_ok( 'qrplop::plop' );


my $plop_factory = qrplop::plop->new();