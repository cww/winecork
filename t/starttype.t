use Modern::Perl;
use Test::More;
use Test::MockObject;

use WineCork::StartType;

=head1 NAME

starttype.t

=head1 SYNOPSIS

    $ prove -Ilib t/starttype.t

=cut

my @tests;
my $num_tests = 0;

# Tests whether types are defined correctly.
push(@tests, 'types');
$num_tests += 3;
sub types
{
    my $start_type = WineCork::StartType->new();
    my $start_types_ref = $start_type->start_types;

    ok(defined($start_types_ref), 'Start types are defined.');
    is(ref($start_types_ref), 'HASH', 'Start types object is a hash ref.');
    cmp_ok(scalar($start_types_ref), '>', 0,
            'More than zero start types are defined.');
}

sub run_tests
{
    plan tests => $num_tests;

    for my $test (@tests)
    {
        if (!defined &$test)
        {
            BAIL_OUT("Test \"$test\" not defined.");
        }
    }

    for my $test (@tests)
    {
        eval "$test";
    }
}

run_tests();
done_testing();

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
