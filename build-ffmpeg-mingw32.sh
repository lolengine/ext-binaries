#!/bin/sh

set -e

T="$HOME/lol/external/ffmpeg-`date +%Y%m%d`"

make distclean || true
./configure --arch=i686 --target-os=mingw32 --cross-prefix=i686-w64-mingw32-
make -j6
make install DESTDIR="$T" LIBDIR="$T/lib/i686-w64-mingw32" INCDIR="$T/include"

make distclean || true
./configure --arch=x86_64 --target-os=mingw32 --cross-prefix=x86_64-w64-mingw32-
make -j6
make install DESTDIR="$T" LIBDIR="$T/lib/x86_64-w64-mingw32"

rm -rf "$T/usr"
find "$T" -name 'lib*.a' | sed -e 's/\(.*\)lib\(.*\).a/& \1\2.lib/' | while read a b; do mv "$a" "$b"; done

