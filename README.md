**The [PlayOnLinux project](http://www.playonlinux.com/en/) does a much better job of this than WineCork.  Go check them out!**

Copyright (C) 2010, Colin Wetherbee

This module is free software.  You can redistribute it and/or
modify it under the terms of the Artistic License 2.0.

This program is distributed in the hope that it will be useful,
but without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

Perl dependencies:

    B::Hooks::EndOfScope
    Carp::Clan
    Clone
    Context::Preserve
    Data::OptList
    ExtUtils::PkgConfig *
    Glib *
    Gtk2
    Moose
    MooseX::Declare
    MRO::Compat
    namespace::autoclean
    Pango *
    Sub::Identify
    Try::Tiny

[*] Dependencies of Gtk2, which should probably be installed via a
distributor-provided package instead of with CPAN.
