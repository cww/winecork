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

class WineCork::Widgets::Menu
{
    method build()
    {
        my $menu = Gtk2::SimpleMenu->new
        (
            menu_tree => &MENU_ITEMS,
        );

        return $menu;
    }
}

1;
