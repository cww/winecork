package WineCork::Widgets::Menu;

use Modern::Perl;

use MooseX::Declare;

use Gtk2::SimpleMenu;

use constant MENU_ITEMS =>
[
    _File =>
    {
        item_type => '<Branch>',
        children =>
        [
            _Quit =>
            {
                callback => sub { Gtk2->main_quit; },
                callback_action => 3,
                accelerator => '<ctrl>Q',
            }
        ],
    },
];

=head1 NAME

WineCork::Widgets::Menu

=head1 SYNOPSIS

    use WineCork::Widgets::Menu;

    my $menu_obj = WineCork::Widgets::Menu->new();
    my $menu = $menu_obj->build();
    $vbox->add($menu->{widget});

=cut

=head1 METHODS

=cut

class WineCork::Widgets::Menu
{
=head2 build()

Builds the main application menu and returns a menu object.

=cut
    method build()
    {
        my $menu = Gtk2::SimpleMenu->new
        (
            menu_tree => &MENU_ITEMS,
        );

        return $menu;
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
