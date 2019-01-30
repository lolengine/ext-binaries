# External binary software for Lol Engine

Main repository: https://github.com/lolengine/lol.git

If any name change occurs, update:
 - `configure.ac`
 - `build/lol-build`
 - `build/msbuild/lol.vars.props`


Glew
----

Download page: http://sourceforge.net/projects/glew/files/glew

- take the pre-compiled glew32s.lib ("s" is for "static") versions for
  both win32 and win64.
- copy include/GL/ in the external directory.


SDL, SDL\_Image, SDL\_Mixer
---------------------------

 - Download both VC (Visual Studio) and mingw32 *devel* releases:
   - http://www.libsdl.org/release/
   - http://www.libsdl.org/projects/SDL_image/release/
   - http://www.libsdl.org/projects/SDL_mixer/release/
 - Copy headers from any version of the package
 - Copy all `.lib` and `.a` files in their respective directories
 - Copy the `.dll` support DLLs into the Visual Studio directories


Libcaca
-------

Ran build-win32 and build-win64 on a Debian installation, copied the
resulting .lib files and some headers.


Ffmpeg
------

Operations to create the Windows binaries:

```
 T=$HOME/lol/external/ffmpeg-`date +%Y%m%d`
 make distclean
 ./configure --arch=i686 --target-os=mingw32 --cross-prefix=i686-w64-mingw32-
 make -j6
 make install DESTDIR=$T LIBDIR=$T/lib/i686-w64-mingw32 INCDIR=$T/include
 make distclean
 ./configure --arch=x86_64 --target-os=mingw32 --cross-prefix=x86_64-w64-mingw32-
 make -j6
 make install DESTDIR=$T LIBDIR=$T/lib/x86_64-w64-mingw32
 rm -rf $T/usr
 find $T -name 'lib*.a' | sed -e 's/\(.*\)lib\(.*\).a/& \1\2.lib/' | while read a b; do mv $a $b; done
```

Phased out
----------

 - libgcc (no longer used, was copied from `gcc-mingw-w64-x86-64` on a Debian system)
Copied from `/usr/lib/gcc/*/4.9-win32/libgcc.a` on Debian systems.

