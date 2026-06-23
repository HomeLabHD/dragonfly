FROM debian:trixie-slim

# Runtime dependency for QCOW2 conversion. Installed BEFORE the binary COPY so this
# layer caches across builds — the binary changes every build, qemu-utils does not.
# (Debian, not Alpine: secure-boot provisioning needs the signed shim/grub + OVMF
# firmware that Alpine doesn't ship.)
RUN apt-get update && apt-get install -y --no-install-recommends qemu-utils \
    && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH
ARG VERSION=0.4.0-alpha4
ARG REVISION=unknown

LABEL org.opencontainers.image.title="Dragonfly" \
      org.opencontainers.image.description="A web application for managing bare metal datacenter infrastructure" \
      org.opencontainers.image.authors="Riff.CC" \
      org.opencontainers.image.vendor="Riff.CC" \
      org.opencontainers.image.licenses="AGPL-3.0" \
      org.opencontainers.image.source="https://gitlab.prplanit.com/riff.cc/dragonfly" \
      org.opencontainers.image.url="https://gitlab.prplanit.com/riff.cc/dragonfly" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${REVISION}"

# App assets (static/, templates/) are embedded in the binary (rust_embed /
# minijinja_embed); the image carries only runtime deps + external mutable data.
COPY --chmod=0755 dragonfly-${TARGETARCH} /usr/local/bin/dragonfly
COPY os-templates/ /opt/dragonfly/os-templates/

VOLUME /var/lib/dragonfly
EXPOSE 3000 67/udp 69/udp
ENV DRAGONFLY_INSTALLED=true
ENTRYPOINT ["dragonfly", "serve"]
