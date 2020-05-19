#!/bin/sh

set -e

CACHEDIR=.conan-cache
RECIPE="${CACHEDIR}/conanfile.txt"

BUILD="Release"
ARCH_LIST="i686 x86_64"
GENERATOR=visual_studio

# Packages that need building because the binary package doesn’t exist
# or does not contain necessary information such as the PDBs.
BUILD_LIST=

for x in conan cmake; do
    if ! which $x >/dev/null 2>&1; then
        echo "Error: missing utility '$x'"
        exit 1
    fi
done

# Initialise recipe file
mkdir -p "${CACHEDIR}"
echo '[requires]' > "${RECIPE}"

case "$1" in
  ssl)
    BUILD_LIST="openssl"
    echo "openssl/1.1.1g" >> "${RECIPE}"
    ;;
  # Does not work yet
  zlib)
    echo "zlib/1.2.11@conan/stable" >> "${RECIPE}"
    ;;
  # Does not work yet
  glew)
    echo "glew/2.1.0@bincrafters/stable" >> "${RECIPE}"
    GENERATOR=
    ;;
  sdl2)
    echo "sdl2/2.0.12@bincrafters/stable" >> "${RECIPE}"
    echo "sdl2_image/2.0.5@bincrafters/stable" >> "${RECIPE}"
    echo "sdl2_mixer/2.0.4@bincrafters/stable" >> "${RECIPE}"
    ;;
  *)
    echo "Usage: $0 [ssl|glew|sdl2]"
    exit 1
esac

echo '[generators]' >> "${RECIPE}"
echo "$GENERATOR" >> "${RECIPE}"

conan remote add -f bincrafters "https://api.bintray.com/conan/bincrafters/public-conan"

for arch in $(echo $ARCH_LIST); do
    conan_arch="$(echo $arch | sed 's/i686/x86/')"

    conan install -s build_type="${BUILD}" -s arch="${conan_arch}" --build ${BUILD_LIST} -if ${CACHEDIR} ${CACHEDIR}

    for pkg in $(sed -ne 's@/.*@@p' < "${RECIPE}"); do
        install_path="$(awk "/<Conan-${pkg}-Root>/ { gsub(/ *<[^>]*> */, "'""'"); print }" "${CACHEDIR}/conanbuildinfo.props")"
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

