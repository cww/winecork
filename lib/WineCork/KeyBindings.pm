package WineCork::KeyBindings;

use Modern::Perl;

use Gtk2;
use Gtk2::Gdk::Keysyms;

use constant MOD_SHIFT => 1;
use constant MOD_CTRL  => 4;
use constant MOD_ALT   => 8;

=head1 NAME

WineCork::KeyBindings

=head1 SYNOPSIS

    use WineCork::KeyBindings;

    $window->signal_connect
    (
        key_press_event => \&WineCork::KeyBindings::key_press_handler,
    );

=cut

=head1 METHODS

=cut

=head2 key_press_handler($widget, $event, $data)

Global key press handler.

=cut

sub key_press_handler
{
    my ($widget, $event, $data) = @_;
    my $state = ${$event->state};

    require Data::Dumper;
    print Data::Dumper::Dumper($event->state);

    given($event->keyval)
    {
        when($Gtk2::Gdk::Keysyms{Q})
        {
            # Quit on CTRL+Q
            if ($state == MOD_CTRL)
            {
                Gtk2->main_quit();
                return 1;
            }
        }
        when($Gtk2::Gdk::Keysyms{q})
        {
            # Quit on CTRL+q
            if ($state == MOD_CTRL)
            {
                Gtk2->main_quit();
                return 1;
            }
        }
    }

    return 0;
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
