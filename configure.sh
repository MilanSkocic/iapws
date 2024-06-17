#!/bin/bash

LIBNAME="libiapws"
NAME="iapws"
PYNAME="py$NAME"
PY_SRC="./src/$PYNAME"

# gfortran libraries
LIBSDARWIN=("libgfortran.5" "libquadmath.0" "libgcc_s.1.1")
LIBSWINDOWS=("libgfortran-5" "libquadmath-0" "libgcc_s_seh-1" "libwinpthread-1")
LIBSLINUX=
ROOTLINUX=/usr/lib/
ROOTDARWIN=/usr/local/opt/gcc/lib/gcc/current
ROOTWINDOWS=/C/msys64/mingw64/bin
ROOT=$ROOTLINUX
LIBS=$LIBSLINUX

# environment variables
FC=gfortran
BUILD_DIR="./build"
INCLUDE_DIR="./include"
FPM_FFLAGS="-std=f2008 -pedantic -Wall -Wextra"
FPM_CFLAGS="-std=c11 -pedantic -Wall -Wextra"
FPM_LDFLAGS=""
DEFAULT_INSTALL_DIR="$HOME/.local"
PLATFORM="linux"
EXT=".so"

if [[ "$OSTYPE" == "msys" ]]; then
    DEFAULT_INSTALL_DIR="${APPDATA//\\//}/local"
    PLATFORM="windows"
    ROOT=$ROOTWINDOWS
    EXT=".dll"
    LIBS=( "${LIBSWINDOWS[@]}" )
fi

if [[ "$OSTYPE" == "darwin"* ]];then
    PLATFORM="darwin"
    ROOT=$ROOTDARWIN
    EXT=".dylib"
    LIBS=( "${LIBSDARWIN[@]}" )
fi

export LIBNAME
echo "LIBNAME=" $LIBNAME

export NAME
echo "NAME=" $NAME

export PLATFORM
echo "PLATFORM=" $PLATFORM

export FPM_FFLAGS
echo "FPM_FFLAGS=" $FPM_FFLAGS

export FPM_CFLAGS
echo "FPM_CFLAGS=" $FPM_CFLAGS

export FPM_LDFLAGS
echo "FPM_LDFLAGS=" $FPM_LDFLAGS

export DEFAULT_INSTALL_DIR
echo "DEFAULT INSTALL DIR=" $DEFAULT_INSTALL_DIR

export BUILD_DIR
echo "BUILD DIR=" $BUILD_DIR

export INCLUDE_DIR
echo "INCLUDE_DIR=" $INCLUDE_DIR

export PY_SRC
echo "PY_SRC=" $PY_SRC

export FC
echo "FC=" $FC


# GFORTRAN LIBRARIES
echo "Gfortran libraries: $ROOT"
for lib in ${LIBS[@]}; do
    fpath=$ROOT/$lib$EXT
    if [ -f "$fpath" ]; then
        echo -n "   $fpath exists."
        cp "$fpath" $PY_SRC
        if [ "$PLATFORM" = "darwin" ]; then
            install_name_tool -change "$fpath" "@loader_path/$lib$EXT" $PY_SRC/$LIBNAME$EXT
            echo " Copied. Changed rpath in $LIBNAME$EXT."
        else
            echo " Copied."
        fi
    else
        echo "   $fpath does not exist."
    fi
done


if [ "$PLATFORM" = "darwin" ]; then
    echo "Check rpaths:"
    otool -L $PY_SRC/$LIBNAME$EXT
fi
