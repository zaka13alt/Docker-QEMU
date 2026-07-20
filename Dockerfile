FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV RESOLUTION=1024x768

# Default hardware environment variables
ENV PPC=FALSE
ENV ARM=FALSE
ENV X86=FALSE
ENV X64=TRUE
ENV MEMORY=2G
ENV CPU=2
ENV CPUTYPE=""
ENV NET=user
ENV ISO_URL=""

# Install QEMU, noVNC, curl, and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    qemu-system-x86 \
    qemu-system-arm \
    qemu-system-ppc \
    qemu-utils \
    novnc \
    websockify \
    curl \
    ca-certificates \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Create the 200GB blank qcow2 image during build
RUN qemu-img create -f qcow2 /workspace/disk.qcow2 200G

# Copy the runtime management script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

CMD ["/entrypoint.sh"]
