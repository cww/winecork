package WineCork::Widgets::MessageBox;

use Modern::Perl;

use List::Util qw(max);
use MooseX::Declare;

class WineCork::Widgets::MessageBox
{
    method start(Str $message)
    {
        my $window = Gtk2::Window->new();
        $window->set_title('Message');

        my $label = Gtk2::Label->new($message);

        my $button = Gtk2::Button->new('_OK');
        $button->signal_connect(clicked => sub { $window->destroy(); });

        my $vbox = Gtk2::VBox->new(0, 6);
        $vbox->pack_start($label, 0, 0, 0);
        $vbox->pack_start($button, 0, 0, 0);

        $window->add($vbox);

        $window->show_all();
    }
}

sub messagebox
{
    my $o = __PACKAGE__->new();
    $o->start(@_);
}

1;
