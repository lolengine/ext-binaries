# External binary software for Lol Engine

Main repository: https://github.com/lolengine/lol.git

If any name change occurs, update:
 - `configure.ac`
 - `build/lol-build`
 - `build/msbuild/lol.vars.props`


OpenSSL
-------

Ensure conan is installed:

 - `pacman -S mingw64/mingw-w64-x86_64-python3-markupsafe`
 - `pacman -S mingw64/mingw-w64-x86_64-python3-yaml`
 - `pip3 install conan`

Then run the script:

 - `download-openssl-msvc.sh`


Glew
----

Download page: http://sourceforge.net/projects/glew/files/glew

 - take the pre-compiled `glew32s.lib` (`s` is for “static”) versions,
   both the win32 and the win64 ones.
 - copy `include/GL` in the glew directory.


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

Ran `build-win32` and `build-win64` on a Debian installation, copied the
resulting `.lib` files and some headers.


Ffmpeg
------

Use the two provided scripts on a fresh ffmpeg Git checkout:

 - `build-ffmpeg-msvc.sh`
 - `build-ffmpeg-mingw32.sh`


Phased out
----------

 - libgcc (can’t remember why it was used, maybe to link mingw32-compiled
   libraries with MSVC, because they may miss `vsprintf` etc.)

