use Test::More;   # see done_testing()
use Try::Tiny;

use Data::Dump qw/ dump /;

BEGIN { use_ok( 'qrplop::plopper' ); }
require_ok( 'qrplop::plopper' );

my $plop_factory = qrplop::plopper->new();
isa_ok($plop_factory, 'qrplop::plopper');

my $plop = $plop_factory->make(path => "/tmp/cute-puppy.jpg");
my $back = $plop_factory->get(id => $plop->oid->to_string);

print "Retrieved plop with value: $back\n";

done_testing();