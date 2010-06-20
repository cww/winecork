package WineCork::StartType;

use Modern::Perl;

use MooseX::Declare;

=head1 NAME

WineCork::StartType

=head1 SYNOPSIS

    use WineCork::StartType;

    # Map a single-letter start type to its full, human-readable name.
    my $st = WineCork::StartType->new();
    my $start_type_readable = $st->start_types->{'D'};

=cut
class WineCork::StartType
{
    has 'start_types' =>
    (
        isa => 'HashRef[Str]',
        is => 'ro',
        default => sub
        {
            {
                D => 'Explorer Desktop',
                W => 'Windowed',
            }
        }
    );
}

=head1 AUTHOR

Colin Wetherbee <cww@cpan.org>

=head1 COPYRIGHT

Copyright (C) 2010, Colin Wetherbee

=head1 LICENSE

This module is free software.  You can redistribute it and/or
modify it under the terms of the Artistic License 2.0.

This program is distributed in the hope that it will be useful,
but without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

=cut

1;
