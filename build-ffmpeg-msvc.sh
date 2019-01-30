#!/bin/sh

set -e

echo "Discovering environment..."
INSTALL_DIR="$(printenv 'ProgramFiles(x86)')/Microsoft Visual Studio/Installer"
DEVENV_DIR="$("$INSTALL_DIR/vswhere" | sed -ne 's/^productPath: //p' | sed 's/.devenv.exe//' | head -n 1)"
CL64_PATH="$(find "$DEVENV_DIR/../.." -name cl.exe | grep 'x64.*/x64/' | sed 's/.cl.exe//')"
CL32_PATH="$(find "$DEVENV_DIR/../.." -name cl.exe | grep 'x86.*/x86/' | sed 's/.cl.exe//')"
T="$HOME/lol/external/ffmpeg-`date +%Y%m%d`"
SAVED_PATH="$PATH"

echo "  vswhere dir: $INSTALL_DIR"
echo "  devenv dir: $DEVENV_DIR"
echo "  64-bit cl dir: $CL64_PATH"
echo "  32-bit cl dir: $CL32_PATH"

set_vs_var() {
  export $2="$(cmd.exe //c "$DEVENV_DIR/../../VC/Auxiliary/Build/vcvars64.bat" $1 '&' set | sed -ne 's/^'$2'=//p')"
}

echo "Setting environment variables for x64..."
set_vs_var x64 INCLUDE
set_vs_var x64 LIB
set_vs_var x64 LIBPATH

echo "Building for x64..."
export PATH="$CL64_PATH:$SAVED_PATH"
make distclean || true
./configure --target-os=win64 --arch=x86_64 --toolchain=msvc 
make -j8
make install DESTDIR="$T" LIBDIR="$T/lib/x86_64-msvc" INCDIR="$T/include"

echo "Setting environment variables for x86..."
set_vs_var x86 INCLUDE
set_vs_var x86 LIB
set_vs_var x86 LIBPATH

echo "Building for x86..."
export PATH="$CL32_PATH:$SAVED_PATH"
make distclean || true
./configure --target-os=win64 --arch=i686 --toolchain=msvc 
make -j8
make install DESTDIR="$T" LIBDIR="$T/lib/i686-msvc"

rm -rf "$T/usr"
find "$T" -name 'lib*.a' | grep msvc | sed -e 's/\(.*\)lib\(.*\).a/& \1\2.lib/' | while read a b; do mv "$a" "$b"; done

exit 0

