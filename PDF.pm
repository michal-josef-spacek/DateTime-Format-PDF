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
			'regex' => qr{^D:(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})([+\-]\d{4})$},
			'params' => [qw(year month day hour minute second time_zone)],
		}],
	},
);
use Error::Pure qw(err);
use Scalar::Util qw(blessed);

our $VERSION = 0.01;

sub format_datetime {
	my ($self, $dt) = @_;

	if (! defined $dt
		|| ! blessed($dt)
		|| ! $dt->isa('DateTime')) {

		err 'Bad DateTime object.',
			'Value', $dt,
		;
	}

	return $dt->strftime("D:%Y%m%d%H%M%S%z");
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

DateTime::Format::PDF - PDF DateTime Parser and Formatter.

=head1 SYNOPSIS

 use DateTime::Format::PDF;

 my $obj = DateTime::Format::PDF->new;
 my $dt = $obj->parse_datetime($pdf_date);
 my $pdf_date = $obj->format_datetime($dt);

=head1 DESCRIPTION

This module understands the formats used by PDF file. It can be used to parse these formats in order
to create L<DateTime> objects, and it can take a DateTime object and produce a string representing
it in a format accepted by PDF.

=head1 METHODS

=head2 C<new>

 my $obj = DateTime::Format::PDF->new(%params);

Constructor.

Returns instance of object.

=head2 C<parse_datetime>

 my $dt = $obj->parse_datetime($pdf_date);

Parse PDF datetime string.

Possible valid strings:

=over

=item C<D:YYYY>

=item C<D:YYYYMM>

=item C<D:YYYYMMDD>

=item C<D:YYYYMMDDHH>

=item C<D:YYYYMMDDHHmm>

=item C<D:YYYYMMDDHHmmSS>

=item C<D:YYYYMMDDHHmmSSZ>

=item C<D:YYYYMMDDHHmmSSOHHmm>

=item C<D:YYYYMMDDHHmmSSOHH'mm>

=item C<D:YYYYMMDDHHmmSSOHH'mm'>

=item C<D:YYYYMMDDHHmmSSOHHmm'>

=back

Returns L<DateTime> object.

=head2 C<format_datetime>

 my $pdf_date = $obj->format_datetime($dt);

Format L<DateTime> object to PDF datetime string.
Output value is C<D:YYYYMMDDHHmmSSOHHmm>.

Returns string.

=head1 ERRORS

TODO

=head1 EXAMPLE1

=for comment filename=parse_pdf_string.pl

 use strict;
 use warnings;

 use DateTime::Format::PDF;

 # Object.
 my $obj = DateTime::Format::PDF->new;

 # Parse date.
 my $dt = $obj->parse_datetime("D:20240401084337-01'30");

 # Print out.
 print $dt->strftime("%a, %d %b %Y %H:%M:%S %z")."\n";

 # Output like:
 # Mon, 01 Apr 2024 08:43:37 -0130

=head1 EXAMPLE2

=for comment filename=format_pdf_string.pl

 use strict;
 use warnings;

 use DateTime;
 use DateTime::Format::PDF;

 # Object.
 my $obj = DateTime::Format::PDF->new;

 # Example date.
 my $dt = DateTime->now;

 # Format.
 my $pdf_date = $obj->format_datetime($dt);

 # Print out.
 print "PDF date: $pdf_date\n";

 # Output like:
 # PDF date: D:20240401084337+0000

=head1 DEPENDENCIES

L<DateTime::Format::Builder>,
L<Error::Pure>,
L<Scalar::Util>.

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/DateTime-Format-PDF>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2024 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
