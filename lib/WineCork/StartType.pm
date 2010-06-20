package WineCork::StartType;

use Modern::Perl;

use MooseX::Declare;

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

    method generate_prefix(Object $prefs, Str $start_type)
    {
        my $prefix;

        given($start_type)
        {
            when('D')
            {
                $prefix = q{};
            }
            when('W')
            {
                $prefix = 'explorer /desktop=foo,' .
                          $prefs->desktop_resolution .
                          ' start ';
            }
        }

        return $prefix;
    }
}

1;
