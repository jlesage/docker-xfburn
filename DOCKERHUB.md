# Docker container for Xfburn
[![Release](https://img.shields.io/github/release/jlesage/docker-xfburn.svg?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-xfburn/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/jlesage/xfburn/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/xfburn/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/jlesage/xfburn?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/xfburn)
[![Docker Stars](https://img.shields.io/docker/stars/jlesage/xfburn?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/xfburn)
[![Build Status](https://img.shields.io/github/actions/workflow/status/jlesage/docker-xfburn/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/jlesage/docker-xfburn/actions/workflows/build-image.yml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-xfburn)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg?style=for-the-badge)](https://paypal.me/JocelynLeSage)

This is a Docker container for [Xfburn](https://docs.xfce.org/apps/xfburn/start).

The graphical user interface (GUI) of the application can be accessed through a
modern web browser, requiring no installation or configuration on the client

> This Docker container is entirely unofficial and not made by the creators of Xfburn.

---

[![Xfburn logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/xfburn-icon.png&w=110)](https://docs.xfce.org/apps/xfburn/start)[![Xfburn](https://images.placeholders.dev/?width=192&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=Xfburn&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://docs.xfce.org/apps/xfburn/start)

Xfburn is an easy to use burning software. It uses libburn and libisofs as a
backend, in difference to most other GUI programs at the moment.

---

## Quick Start

**NOTE**:
    The Docker command provided in this quick start is an example, and parameters
    should be adjusted to suit your needs.

Launch the Xfburn docker container with the following command:
```shell
docker run -d \
    --name=xfburn \
    -p 5800:5800 \
    -v /docker/appdata/xfburn:/config:rw \
    -v /home/user:/storage:ro \
    --device /dev/sr0 \
    jlesage/xfburn
```

Where:

  - `/docker/appdata/xfburn`: Stores the application's configuration, state, logs, and any files requiring persistency.
  - `/home/user`: Contains files from the host that need to be accessible to the application.
  - `/dev/sr0`: Linux device file corresponding to the optical drive.

Access the Xfburn GUI by browsing to `http://your-host-ip:5800`.
Files from the host appear under the `/storage` folder in the container.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-xfburn.

## Support or Contact

Having troubles with the container or have questions? Please
[create a new issue](https://github.com/jlesage/docker-xfburn/issues).

For other Dockerized applications, visit https://jlesage.github.io/docker-apps.
