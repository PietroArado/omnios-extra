#!/usr/bin/bash
#
# {{{ CDDL HEADER
#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source. A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
# }}}

# Copyright 2026 OmniOS Community Edition (OmniOSce) Association.

. ../../lib/build.sh

PROG=garage
VER=2.2.0
PKG=ooce/storage/garage
SUMMARY="Garage object storage"
DESC="S3-compatible distributed object storage service designed for self-hosting at a small-to-medium scale."

set_arch 64

OPREFIX=$PREFIX
PREFIX+=/$PROG

XFORM_ARGS="
    -DOPREFIX=${OPREFIX#/}
    -DPREFIX=${PREFIX#/}
    -DPROG=$PROG
    -DUSER=garage
    -DGROUP=garage
"

SKIP_SSP_CHECK=1
BMI_EXPECTED=1

pre_build() {
    typeset arch=$1
    
    export RUSTFLAGS="-C link-arg=-R$OPREFIX/${LIBDIRS[$arch]}"
    export LD_LIBRARY_PATH="$OPREFIX/${LIBDIRS[$arch]}"
}

init
clone_github_source -submodules $PROG "https://git.deuxfleurs.fr/Deuxfleurs/$PROG" "v$VER"
append_builddir $PROG
SODIUM_USE_PKG_CONFIG=1 build_rust
install_rust
VER=${VER//-/.} make_package
clean_up
