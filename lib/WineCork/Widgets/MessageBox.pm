package WineCork::Widgets::MessageBox;

use Modern::Perl;

use List::Util qw(max);
use MooseX::Declare;

=head1 NAME

WineCork::Widgets::MessageBox

=head1 SYNOPSIS

    use WineCork::Widgets::MessageBox;

    my $msg = "Hello, World!";
    WineCork::Widgets::MessageBox::messagebox($msg);

=cut

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

=head1 METHODS

=cut

=head2 messagebox($msg)

Creates a modal message box dialog with the specified message.

=cut

sub messagebox
{
    my $o = __PACKAGE__->new();
    $o->start(@_);
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
