use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'dancer_bootstrap_fontawesome_template',
    AUTHOR              => q{YOUR NAME <youremail@example.com>},
    VERSION_FROM        => 'lib/dancer_bootstrap_fontawesome_template.pm',
    ABSTRACT            => 'YOUR APPLICATION ABSTRACT',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
		'MongoDB' => '0.45',
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer'     => 1.3095,
		'Plack'      => 0.9976,
		'Plack::Request' => '0.9976',
		'Template' => '2.24',
		'Data::Dump' => '1.21',
		'Imager::QRCode' => '0.033',
		'String::Random' => '0.22',
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'dancer_bootstrap_fontawesome_template-*' },
);
