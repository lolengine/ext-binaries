#!/bin/sh

set -x
set -e

CACHE=.conan-cache

BUILD="Release"
ARCH_LIST="i686 x86_64"

# Packages we want
#PKG_LIST="openssl zlib sdl2 sdl2_mixer sdl2_image"
PKG_LIST="openssl"

# Packages that need building because the binary package doesn’t exist
# or does not contain necessary information such as the PDBs.
BUILD_LIST="openssl"

for arch in $(echo $ARCH_LIST); do
    conan_arch="$(echo $arch | sed 's/i686/x86/')"

    conan install -s build_type="${BUILD}" -s arch="${conan_arch}" --build ${BUILD_LIST} -if ${CACHE} .

    for pkg in $(echo $PKG_LIST); do
        install_path="$(awk "/<Conan-${pkg}-Root>/ { gsub(/ *<[^>]*> */, "'""'"); print }" "${CACHE}/conanbuildinfo.props")"
        source_path="$(echo "${install_path}" | sed 's@_/package/@_/build/@')"
        chunks="$(echo "${install_path}" | sed 's@.*\.conan/data/@@')"
        test "${pkg}" = "$(echo "${chunks}" | cut -f1 -d/)"
        version="$(echo "$chunks" | cut -f2 -d/)"
        lib_path="${pkg}-${version}/lib/${arch}-msvc"
        include_path="${pkg}-${version}/include"

        rm -rf "${lib_path}" "${include_path}"
        mkdir -p "${lib_path}" "${include_path}"
        find "${source_path}/source_subfolder" -name '*static.pdb' -exec cp {} "${lib_path}/" ';'
        cp -rv "${install_path}"/lib/* "${lib_path}/"
        cp -rv "${install_path}"/include/* "${include_path}/"
    done
done

