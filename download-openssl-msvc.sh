#!/bin/sh

set -e

CACHE=.conan-cache

## Install on MSYS2:
# pacman -S mingw64/mingw-w64-x86_64-python3-markupsafe
# pacman -S mingw64/mingw-w64-x86_64-python3-yaml
# pip3 install conan

for arch in i686 x86_64; do
    conan_arch="$(echo $arch | sed 's/i686/x86/')"
    conan install -s build_type=Debug -s arch="${conan_arch}" -if ${CACHE} . \
      || conan install -s build_type=Debug -s arch="${conan_arch}" --build openssl -if ${CACHE} .
    for pkg in openssl zlib sdl2; do
        install_path="$(awk "/<Conan-${pkg}-Root>/ { gsub(/ *<[^>]*> */, "'""'"); print }" "${CACHE}/conanbuildinfo.props")"
        chunks="$(echo "$install_path" | sed 's@.*\.conan/data/@@')"
        test "${pkg}" = "$(echo "$chunks" | cut -f1 -d/)"
        version="$(echo "$chunks" | cut -f2 -d/)"
        lib_path="${pkg}-${version}/lib/${arch}-msvc"
        include_path="${pkg}-${version}/include"
        rm -rf "${lib_path}" "${include_path}"
        mkdir -p "${lib_path}" "${include_path}"
        cp -rv "${install_path}"/lib/* "${lib_path}/"
        cp -rv "${install_path}"/include/* "${include_path}/"
    done
done

