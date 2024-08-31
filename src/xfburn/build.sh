#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Set same default compilation flags as abuild.
export CFLAGS="-Os -fomit-frame-pointer"
export CXXFLAGS="$CFLAGS"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-Wl,--strip-all -Wl,--as-needed"

export CC=xx-clang
export CXX=xx-clang++

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

function log {
    echo ">>> $*"
}

XFBURN_URL="$1"

if [ -z "$XFBURN_URL" ]; then
    log "ERROR: Xfburn URL missing."
    exit 1
fi

#
# Install required packages.
#
apk --no-cache add \
    curl \
    clang \
    make \
    pkgconf \
    patch \
    gettext \

xx-apk --no-cache --no-scripts add \
    musl-dev \
    gcc \
    exo-dev \
    gst-plugins-base-dev \
    thunar-dev \
    libburn-dev \
    libisofs-dev \
    libxfce4ui-dev \

#
# Download sources.
#

log "Downloading Xfburn package..."
mkdir /tmp/xfburn
curl -# -L -f ${XFBURN_URL} | tar xj --strip 1 -C /tmp/xfburn

#
# Compile Xfburn.
#

log "Patching Xfburn..."
PATCHES="
    disable-file-browser-home.patch
    fix-file-browser-folder-icon.patch
"
for PATCH in $PATCHES; do
    echo "Applying $PATCH..."
    patch -p1 -d /tmp/xfburn < "$SCRIPT_DIR"/"$PATCH"
done

log "Configuring Xfburn..."
(
    cd /tmp/xfburn && \
    # shared-mime-info.pc is installed under /usr/share/pkgconfig.
    PKG_CONFIG_PATH=/$(xx-info)/usr/share/pkgconfig \
    ./configure \
        --build=$(TARGETPLATFORM= xx-clang --print-target-triple) \
        --host=$(xx-clang --print-target-triple) \
        --prefix=/usr \
        --enable-gstreamer \
)

log "Compiling Xfburn..."
make -C /tmp/xfburn -j$(nproc)

log "Installing Xfburn..."
make DESTDIR=/tmp/xfburn-install -C /tmp/xfburn install
