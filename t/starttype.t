use Modern::Perl;
use Test::More;
use Test::MockObject;

use WineCork::StartType;

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

# Tests whether types have defined run prefixes.
push(@tests, 'run_prefixes');
$num_tests += 2;
sub run_prefixes
{
    my $m = Test::MockObject->new();
    $m->fake_module
    (
        'WineCork::Prefs',
        new                => sub { bless({}, $_[0]) },
        desktop_resolution => sub { '1x1' },
    );
    my $p = WineCork::Prefs->new();

    my $start_type = WineCork::StartType->new();
    
    for my $key (keys %{$start_type->start_types})
    {
        my $run_prefix = $start_type->generate_prefix($p, $key);
        ok(defined($run_prefix), "Run prefix for key [$key] is defined.");
    }
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

