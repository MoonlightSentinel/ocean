/*******************************************************************************

    Copyright:
        Copyright (c) 2009-2016 dunnhumby Germany GmbH.
        All rights reserved.

    License:
        Boost Software License Version 1.0. See LICENSE_BOOST.txt for details.
        Alternatively, this file may be distributed under the terms of the Tango
        3-Clause BSD License (see LICENSE_BSD.txt for details).

*******************************************************************************/


module ocean.stdc.string;

public import core.stdc.string;
public import core.stdc.wchar_;

public import ocean.stdc.gnu.string;

extern (C):

static if (__VERSION__ < 2089)
{
    char *strsignal(int sig);
    int strcasecmp(in char *s1, in char *s2);
    int strncasecmp(in char *s1, in char *s2, size_t n);
}
else
{
    public import core.sys.posix.string  : strsignal;
    public import core.sys.posix.strings : strcasecmp, strncasecmp;
}
