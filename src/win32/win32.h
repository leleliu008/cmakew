/*
*   Copyright (c) 2002-2003, Darren Hiebert
*
*   This source code is released for free distribution under the terms of the
*   GNU General Public License version 2 or (at your option) any later version.
*
*   Configures ctags for Microsoft environment.
*/
# ifndef WIN32_H
# define WIN32_H

# define CASE_INSENSITIVE_FILENAMES
# define MANUAL_GLOBBING
# define MSDOS_STYLE_PATH

// https://docs.microsoft.com/en-us/cpp/c-runtime-library/reference/findfirst-functions?view=msvc-160
# define findfirst_t intptr_t

# ifndef HAVE_MKSTEMP
# define HAVE_MKSTEMP
  int mkstemp (char *template_name);
# endif

# define TMPDIR "\\"

//https://docs.microsoft.com/en-us/cpp/preprocessor/predefined-macros?view=msvc-160
# ifdef _MSC_VER

    // https://stackoverflow.com/questions/119578/disabling-warnings-generated-via-crt-secure-no-deprecate/121573
    # ifndef _CRT_SECURE_NO_DEPRECATE
    # define _CRT_SECURE_NO_DEPRECATE
    # endif

    # pragma warning(disable : 4996)

#elif defined (__MINGW32__)

    # include <_mingw.h>
    # define ffblk _finddata_t
    # define FA_DIREC _A_SUBDIR
    # define ff_name name

# endif

# endif
