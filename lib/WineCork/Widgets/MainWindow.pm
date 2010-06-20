package WineCork::Widgets::MainWindow;

use Modern::Perl;

use Data::Dumper;
use List::Util qw(max);
use MooseX::Declare;
use Proc::Daemon;

use WineCork::StartType;
use WineCork::Widgets::MessageBox;

=head1 NAME

WineCork::Widgets::MainWindow

=head1 SYNOPSIS

    use Gtk2 '-init';
    use WineCork::Prefs;
    use WineCork::Widgets::MainWindow;

    my $prefs = WineCork::Prefs->new();
    $prefs->populate();

    WineCork::Widgets::MainWindow::mainwindow($prefs);
    Gtk2->main();

=cut

class WineCork::Widgets::MainWindow
{
    method start(Any $prefs)
    {
        my $apps_ref = $prefs->apps();

        # This is the main vertical box in the main window.
        my $vbox = Gtk2::VBox->new();

        if (defined($apps_ref) && scalar(@$apps_ref) > 0)
        {
            my $vbox_apps = Gtk2::VBox->new();

            # Draw an horizontal block for each app.
            for my $app_ref (@$apps_ref)
            {
                my $label = Gtk2::Label->new($app_ref->{name});

                # Build the tooltip for the label.
                my $tt = Gtk2::Tooltips->new();
                my $tt_text = $self->_build_tooltip($prefs, $app_ref);
                $tt->set_tip($label, $tt_text);

                # Build the edit button.
                my $button_edit = Gtk2::Button->new('Edit');
                $button_edit->signal_connect
                (
                    clicked => $self->_generate_edit_closure($prefs, $app_ref),
                );

                # Build the run button.
                my $button_run = Gtk2::Button->new('Run');
                $button_run->signal_connect
                (
                    clicked => $self->_generate_run_closure($prefs, $app_ref),
                );

                my $hbox = Gtk2::HBox->new();
                $hbox->add($label);
                $hbox->add($button_edit);
                $hbox->add($button_run);

                $vbox_apps->pack_start($hbox, 1, 1, 0);
            }

            my $frame = Gtk2::Frame->new('Applications');
            $frame->add($vbox_apps);
            $vbox->pack_start($frame, 0, 0, 0);
        }
        else
        {
            # XXX
            die;
        }

        my $window = Gtk2::Window->new();
        $window->signal_connect(destroy => sub { Gtk2->main_quit(); });
        $window->add($vbox);
        $window->show_all();
    }

    method _generate_edit_closure(Any $prefs, Any $app_ref)
    {
        return sub
        {
        };
    }

    method _generate_run_closure(Any $prefs, Any $app_ref)
    {
        my $wineprefix_id = $app_ref->{wineprefix_id};
        my $install_id = $app_ref->{install_id};

        my $wineprefix = $prefs->wineprefix_by_id($wineprefix_id);
        my $install = $prefs->install_by_id($install_id);
        my $bin = "$install/bin/wine";
        my $resolution = $prefs->desktop_resolution;

        my @cmd;

        given ($app_ref->{start_type})
        {
            when('D')
            {
                @cmd =
                (
                    $bin,
                    'explorer',
                    "/desktop=foo,$resolution",
                    'start',
                    $app_ref->{command},
                );
            }
            when('W')
            {
                @cmd =
                (
                    $bin,
                    $app_ref->{command},
                );
            }
            default
            {
                return sub
                {
                    my $msg = "Invalid start_type: $app_ref->{start_type}";
                    WineCork::Widgets::MessageBox::messagebox($msg);
                };
            }
        }

        return sub
        {
            my $pid = fork();

            if (!defined $pid)
            {
                my $msg = "Fork was unsuccessful: $!";
                WineCork::Widgets::MessageBox::messagebox($msg);
            }
            elsif ($pid != 0)
            {
                print "Setting WINEPREFIX to: $wineprefix\n";
                print "Running command:\n" . Data::Dumper::Dumper(\@cmd);
            }
            else
            {
                Proc::Daemon::Init();

                $ENV{WINEPREFIX} = $wineprefix;

                if (!exec(@cmd))
                {
                    my $msg = 'Unable to execute command: ' .
                              join(q{ }, @cmd) . ": $!";
                    WineCork::Widgets::MessageBox::messagebox($msg);
                }
            }
        };
    }

    method _build_tooltip(Any $prefs, Any $app_ref)
    {
        my $st = WineCork::StartType->new();
        my $start_type = $st->start_types->{$app_ref->{start_type}};
        my @tip_labels = ('Prefix', 'Install', 'Start Type');
        $self->_post_indent_list(\@tip_labels);
        my $tip =
            $tip_labels[0] .
            $prefs->wineprefix_by_id($app_ref->{wineprefix_id}) .
            "\n" .
            $tip_labels[1] .
            $prefs->install_by_id($app_ref->{install_id}) .
            "\n" .
            $tip_labels[2] .
            $start_type;

        return $tip;
    }

    # Append tabs to the end of each element in an array such that the
    # end of the tabs will all line up if each element is printed.
    method _post_indent_list(ArrayRef $strings_ref)
    {
        my $tabs = 0;

        for my $str (@$strings_ref)
        {
            $tabs = max($tabs, int(length($str) / 8.0) + 1);
        }

        for (my $i = 0; $i < scalar(@$strings_ref); ++$i)
        {
            my $num_tabs = $tabs - int(length($strings_ref->[$i]) / 8.0);
            $strings_ref->[$i] .= "\t" x $num_tabs;
        }
    }
}

=head1 METHODS

=cut

=head2 mainwindow($prefs)

Creates the application's main window.

=cut

sub mainwindow
{
    my $o = __PACKAGE__->new();
    return $o->start(@_);
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
