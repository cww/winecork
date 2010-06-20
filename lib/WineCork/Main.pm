package WineCork::Main;

use Modern::Perl;

use Gtk2 '-init';
use MooseX::Declare;

use WineCork::Prefs;
use WineCork::Widgets::MainWindow;

=head1 NAME

WineCork::Main

=head1 SYNOPSIS

    use WineCork::Main

    my $cork = WineCork::Main->new();
    my $exit_code = $cork->main();

=cut

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
