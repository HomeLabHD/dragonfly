FROM alpine:3.24.1
ARG TARGETARCH
COPY dragonfly-agent-${TARGETARCH} /usr/local/bin/dragonfly-agent
RUN chmod +x /usr/local/bin/dragonfly-agent \
    && apk add --no-cache libgcc kexec-tools
CMD ["dragonfly-agent"]
