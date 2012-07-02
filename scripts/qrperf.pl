#!/usr/bin/env perl

use warnings;
use strict;

use Imager::QRCode;
use Data::Dump qw(dump);
use String::Random;

my @sizes = qw/ 1 2 3 4 5 6 7 8 9 /;
my @margins = qw/ 0 1 2 3 4 5 6 7 8 9 /;
my @levels = qw / M L Q H /;

my @colors = (1 .. 255);

my ($number_of_qr_codes, $cached_factory, $extension) = @ARGV;
die "usage: $0 [number to test] [cached_factory=0] [extension=gif]\n"
	unless defined $number_of_qr_codes;

$cached_factory ||= 0;
$extension ||= "gif";

my $outfile = "/tmp/qr.$extension";
my $i = 0;
while ($i++ < $number_of_qr_codes) {
	generate_code($outfile);
}

sub generate_code {
	my $outfile = shift(@_);
	my $qr_factory = fetch_qr_factory();
	my $string_factory = String::Random->new();
	my $string = $string_factory->randpattern("." x (rand(100) + 2));

	my $img = $qr_factory->plot($string);

	$img->write(file => $outfile)
		or die "Unable to write $outfile, reason: ".$img->errstr."\n";
}

my $singleton = undef;
sub fetch_qr_factory {
	return $singleton if defined $singleton;

	my $retval =  Imager::QRCode->new(
		size          => $sizes[rand @sizes],
		margin        => $margins[rand @margins],
		version       => 1,
		level         => $levels[rand @levels],
		casesensitive => 1,
		lightcolor    => Imager::Color->new($colors[rand @colors], 
							$colors[rand @colors],
							$colors[rand @colors]),
		darkcolor     => Imager::Color->new($colors[rand @colors],
							$colors[rand @colors], 
							$colors[rand @colors]),
	    );
	
	$singleton = $retval if $cached_factory == 1;
	$retval;
}
