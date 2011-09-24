Using the MinGW-friendly GDI+ headers
=====================================

The headers have been tweaked in order to remove compilation errors for building with MinGW's gcc
compiler.

The files from the include folder can either be dropped into your MinGW include folder, or you can
add the include path to your compilation options.

The libgdiplus.a archive is included for linking. For wxMax, this should be dropped into your
wx.mod/lib/win32 folder. (Note that this file is included in the standard static libs archive).


:o)

Brucey


