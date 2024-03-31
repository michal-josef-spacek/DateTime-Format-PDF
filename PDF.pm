package DateTime::Format::PDF;

use strict;
use warnings;

use DateTime::Format::Builder (
	'parsers' => {
		'parse_datetime' => [[
			'preprocess' => sub {
				my %args = @_;
				my ($date, $p) = @args{qw(input parsed)};
				if ($date =~ s/(\d{2})'?(\d{2})'?$/$1$2/ms) {
				} elsif ($date =~ s/Z$//ms) {
					$p->{'time_zone'} = 'UTC';
				}
				return $date;
			},
		], {
			'length' => 6,
			'regex' => qr{^D:(\d{4})$},
			'params' => ['year'],
		}, {
			'length' => 8,
			'regex' => qr{^D:(\d{4})(\d{2})$},
			'params' => [qw(year month)],
		}, {
			'length' => 10,
			'regex' => qr{^D:(\d{4})(\d{2})(\d{2})$},
			'params' => [qw(year month day)],
		}, {
			'length' => 12,
			'regex' => qr{^D:(\d{4})(\d{2})(\d{2})(\d{2})$},
			'params' => [qw(year month day hour)],
		}, {
			'length' => 14,
			'regex' => qr{^D:(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})$},
			'params' => [qw(year month day hour minute)],
		}, {
			'length' => 16,
			'regex' => qr{^D:(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$},
			'params' => [qw(year month day hour minute second)],
		}, {
			'length' => 17,
			'regex' => qr{^D:(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})Z$},
			'params' => [qw(year month day hour minute second)],
		}, {
			'regex' => qr{^D:(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})([+\-]\d{4})$},
			'params' => [qw(year month day hour minute second time_zone)],
		}],
	},
);

our $VERSION = 0.01;

sub format_datetime {
	my ($self, $dt) = @_;

	return $dt->strftime("D:%Y%m%d%H%M%S%z");
}

1;
