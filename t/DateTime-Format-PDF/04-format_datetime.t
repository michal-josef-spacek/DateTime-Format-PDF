use strict;
use warnings;

use DateTime;
use DateTime::Format::PDF;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
my $obj = DateTime::Format::PDF->new;
my $dt = DateTime->new(
	'day' => 23,
	'month' => 1,
	'year' => 2024,
	'time_zone' => '+0130',
	'hour' => 10,
	'minute' => 11,
	'second' => 12,
);
my $ret = $obj->format_datetime($dt);
is($ret, "D:20240123101112+0130", 'Format PDF datetime.');
