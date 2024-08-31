#
# xfburn Dockerfile
#
# https://github.com/jlesage/docker-xfburn
#

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Define software versions.
ARG XFBURN_VERSION=0.7.2

# Define software download URLs.
ARG XFBURN_URL=https://archive.xfce.org/src/apps/xfburn/0.7/xfburn-${XFBURN_VERSION}.tar.bz2

# Get Dockerfile cross-compilation helpers.
FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

# Build Xfburn.
FROM --platform=$BUILDPLATFORM alpine:3.20 AS xfburn
ARG TARGETPLATFORM
ARG XFBURN_URL
COPY --from=xx / /
COPY src/xfburn /build
RUN /build/build.sh "$XFBURN_URL"
RUN xx-verify /tmp/xfburn-install/usr/bin/xfburn

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.20-v4.6.4

ARG XFBURN_VERSION
ARG DOCKER_IMAGE_VERSION

# Define working directory.
WORKDIR /tmp

# Install dependencies.
RUN add-pkg \
        gtk+3.0 \
        gst-plugins-base \
        gst-plugins-good \
        gst-plugins-bad \
        gst-plugins-ugly \
        exo-libs \
        libburn \
        libisofs \
        libxfce4ui \
        adwaita-icon-theme \
        # A font is needed.
        font-croscore \
        # For optical drive listing:
        lsscsi

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/jlesage/docker-templates/raw/master/jlesage/images/xfburn-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY --from=xfburn /tmp/xfburn-install/ /

# Icons were added by Xfburn.
RUN gtk-update-icon-cache -f -t /usr/share/icons/hicolor

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "Xfburn" && \
    set-cont-env APP_VERSION "$XFBURN_VERSION" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Define mountable directories.
VOLUME ["/storage"]

# Metadata.
LABEL \
      org.label-schema.name="xfburn" \
      org.label-schema.description="Docker container for Xfburn" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-xfburn" \
      org.label-schema.schema-version="1.0"
