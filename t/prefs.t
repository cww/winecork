use Modern::Perl;
use Test::More;
use Test::MockObject;

use IO::String;

use WineCork::Prefs;

my @tests;
my $num_tests = 0;

sub _build_config
{
    my ($config_ref) = @_;

    my $config = q{};

    for my $key (keys %$config_ref)
    {
        if (ref($config_ref->{$key}) eq 'ARRAY')
        {
            for my $value (@{$config_ref->{$key}})
            {
                $config .= "$key $value\n";
            }
        }
        else
        {
            $config .= "$key $config_ref->{$key}\n";
        }
    }

    return $config;
}

# Tests config parser.
push(@tests, 'parse_config');
$num_tests += 1;
sub parse_config 
{
    my %conf =
    (
        version => '2048',
        desktop_resolution => '958273x418204',
        install =>
        [
            '0,/aaa/bbb',
            '1,/c/d/e/f/g',
        ],
        wineprefix =>
        [
            '0,/zzz/yyy',
            '1,/x/w/v/u/t',
        ],
        app =>
        [
            'zzz,0,1,D,foo',
        ],
    );
    my $conf_str = _build_config(\%conf);
    my $fh = IO::String->new($conf_str);

    my $m = Test::MockObject->new();
    $m->fake_module
    (
        'IO::File',
        new  => sub { $fh },
    );
    $m->fake_module
    (
        'IO::String',
        open => sub { 1 },
    );

    my $p = WineCork::Prefs->new();
    $p->populate();

    my %conf_test =
    (
        version => $p->version(),
        desktop_resolution => $p->desktop_resolution(),
        wineprefix =>
        [
            map
            {
                $_->{id} . q{,} . $_->{path}
            } @{$p->wineprefixes()},
        ],
        install =>
        [
            map
            {
                $_->{id} . q{,} . $_->{path}
            } @{$p->installs()},
        ],
        app =>
        [
            map
            {
                join(q{,}, $_->{name}, $_->{wineprefix_id}, $_->{install_id},
                           $_->{start_type}, $_->{command})
            } @{$p->apps()},
        ],
    );

    is_deeply(\%conf_test, \%conf, 'Configuration stored correctly.');
}

# Tests whether wineprefix_by_id correctly returns undef on failure.
push(@tests, 'wineprefix_by_id_fail');
$num_tests += 1;
sub wineprefix_by_id_fail
{
    my $p = WineCork::Prefs->new();
    my $str = $p->wineprefix_by_id(1);

    ok(!defined($str), 'Undefined return from wineprefix_by_id().');
}

# Tests whether install_by_id correctly returns undef on failure.
push(@tests, 'install_by_id_fail');
$num_tests += 1;
sub install_by_id_fail
{
    my $p = WineCork::Prefs->new();
    my $str = $p->install_by_id(1);

    ok(!defined($str), 'Undefined return from install_by_id().');
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

