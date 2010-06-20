package WineCork::Main;

use Modern::Perl;

use Gtk2 '-init';
use MooseX::Declare;

use WineCork::Prefs;
use WineCork::Widgets::MainWindow;

class WineCork::Main
{
    method main
    {
        my $prefs = WineCork::Prefs->new();
        $prefs->populate();

        WineCork::Widgets::MainWindow::mainwindow($prefs);

        Gtk2->main();

        0;
    }
}

1;
