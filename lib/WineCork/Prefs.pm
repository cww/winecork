package WineCork::Prefs;

use Modern::Perl;

use IO::File;
use MooseX::Declare;

use WineCork::StartType;
use WineCork::Widgets::MessageBox;

use constant DEFAULT_LOCATION => "$ENV{HOME}/.winecorkrc";

=head1 NAME

WineCork::Prefs

=head1 SYNOPSIS

    use WineCork::Prefs;

    # Read ~/.winecorkrc, parse its contents, and populate a handful of data
    # structures.
    my $prefs = WineCork::Prefs->new();
    $prefs->populate();

    my $wineprefix = $prefs->wineprefix_by_id(0);
    my $install = $prefs->install_by_id(0);
=cut

class WineCork::Prefs
{
    has 'wineprefixes' =>
    (
        isa => 'ArrayRef[HashRef]',
        is => 'rw',
    );
    has 'installs' =>
    (
        isa => 'ArrayRef[HashRef]',
        is => 'rw',
    );
    has 'apps' =>
    (
        isa => 'ArrayRef[HashRef]',
        is => 'rw',
    );
    has 'desktop_resolution' =>
    (
        isa => 'Str',
        is => 'rw',
        default => '800x600',
    );
    has 'version' =>
    (
        isa => 'Num',
        is => 'rw',
    );

=head1 METHODS

=cut

=head2 populate()

Populates the internal data structures by parsing a configuration file on
disk.

=cut
    method populate
    {
        my $fh = IO::File->new();

        if ($fh->open('<' . DEFAULT_LOCATION))
        {
            $self->_load_from_stream($fh);
        }
    }

=head2 wineprefix_by_id($wineprefix_id)

Given a wineprefix_id, returns the string representation of the related
wineprefix value.

=cut
    method wineprefix_by_id(Num $id)
    {
        my $wineprefixes_ref = $self->wineprefixes;
        for my $wineprefix_ref (@$wineprefixes_ref)
        {
            if ($wineprefix_ref->{id} == $id)
            {
                return $wineprefix_ref->{path};
            }
        }

        return undef;
    }

=head2 install_by_id($install_id)

Given an install_id, returns the string representation of the related install
value.

=cut
    method install_by_id(Num $id)
    {
        my $installs_ref = $self->installs;
        for my $install_ref (@$installs_ref)
        {
            if ($install_ref->{id} == $id)
            {
                return $install_ref->{path};
            }
        }

        return undef;
    }

    # Load an rc file from the stream in the provided file handle.
    method _load_from_stream(Object $fh)
    {
        my @error_lines;

        my $line_num = 0;
        while (my $line = <$fh>)
        {
            ++$line_num;

            # Skip comments and empty lines.
            next if ($line =~ /^ *#/ || $line =~ /^ *$/);

            # Parse key-value pairs.
            if ($line =~ /^(\w+) +(.+)$/)
            {
                my ($key, $value) = ($1, $2);

                if (!$self->_parse_kv($key, $value))
                {
                    push(@error_lines, $line_num);
                }
            }
            else
            {
                push(@error_lines, $line_num);
            }
        }

        # Produce error messages, if required.
        if (scalar @error_lines > 0)
        {
            my $msg;

            if (scalar @error_lines == 1)
            {
                $msg = "Error on line $error_lines[0] of configuration file.";
            }
            else
            {
                my $lines = join(q{, }, @error_lines);
                $msg = "Errors on lines $lines of configuration file.";
            }

            WineCork::Widgets::MessageBox::messagebox($msg);
        }
    }

    # Parses a key-value pair and adds it to the related array.  Returns a
    # true value on success or a false value on failure.
    method _parse_kv(Str $key, Any $value)
    {
        my $success = 1;

        given($key)
        {
            when('version')
            {
                $self->version($value);
            }
            when('wineprefix')
            {
                if ($value =~ /^(\d+),(.+)$/)
                {
                    my %h =
                    (
                        id => $1,
                        path => $2,
                    );
                    $self->wineprefixes
                    (
                        $self->_push_array($self->wineprefixes, \%h)
                    );
                }
                else
                {
                    $success = 0;
                }
            }
            when('install')
            {
                if ($value =~ /^(\d+),(.+)$/)
                {
                    my %h =
                    (
                        id => $1,
                        path => $2,
                    );
                    $self->installs($self->_push_array($self->installs, \%h));
                }
                else
                {
                    $success = 0;
                }
            }
            when('app')
            {
                if ($value =~ /^(.*),(\d+),(\d+),(\w+),(.*?)$/)
                {
                    my %h =
                    (
                        name => $1,
                        wineprefix_id => $2,
                        install_id => $3,
                        start_type => $4,
                        command => [ split(/,/, $5) ],
                    );

                    if (exists WineCork::StartType->new()->start_types->
                               {$h{start_type}})
                    {
                        $self->apps($self->_push_array($self->apps, \%h));
                    }
                    else
                    {
                        $success = 0;
                    }
                }
                else
                {
                    $success = 0;
                }
            }
            when('desktop_resolution')
            {
                if ($value =~ /^(\d+x\d+)$/)
                {
                    $self->desktop_resolution($1);
                }
                else
                {
                    $success = 0;
                }
            }
            default
            {
                $success = 0;
            }
        }

        return $success;
    }

    # Push an object onto an array ref, creating the array ref if necessary.
    method _push_array(Any $arrayref, Any $value)
    {
        if (!defined $arrayref)
        {
            $arrayref = [];
        }

        push(@$arrayref, $value);
        return $arrayref;
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
