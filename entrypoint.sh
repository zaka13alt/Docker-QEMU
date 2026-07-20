#!/bin/bash

# Download the ISO if a URL is provided
CDROM_ARG=""
if [ -n "$ISO_URL" ]; then
    echo "Downloading ISO from: $ISO_URL"
    # -f fails silently on server errors, -S shows errors if it fails, -s runs silently, -L follows redirects
    if curl -fSsL "$ISO_URL" -o /workspace/boot.iso; then
        echo "ISO downloaded successfully."
        CDROM_ARG="-cdrom /workspace/boot.iso"
    else
        echo "Error: ISO download failed!"
        exit 1
    fi
fi

# Determine architecture binary and default CPU if CPUTYPE is not provided
if [ "$X64" = "TRUE" ]; then
    QEMU_BIN="qemu-system-x86_64"
    DEFAULT_MACHINE=""
    DEFAULT_CPU="qemu64"
elif [ "$X86" = "TRUE" ]; then
    QEMU_BIN="qemu-system-i386"
    DEFAULT_MACHINE=""
    DEFAULT_CPU="qemu32"
elif [ "$ARM" = "TRUE" ]; then
    QEMU_BIN="qemu-system-aarch64"
    DEFAULT_MACHINE="-machine virt"
    DEFAULT_CPU="cortex-a57"
elif [ "$PPC" = "TRUE" ]; then
    QEMU_BIN="qemu-system-ppc"
    DEFAULT_MACHINE="-machine g3beige"
    DEFAULT_CPU="g3"
else
    echo "No architecture enabled. Defaulting to X64."
    QEMU_BIN="qemu-system-x86_64"
    DEFAULT_MACHINE=""
    DEFAULT_CPU="qemu64"
fi

# Use CPUTYPE if provided by the user, otherwise fall back to the default
SELECTED_CPU="${CPUTYPE:-$DEFAULT_CPU}"

echo "Starting $QEMU_BIN..."
echo "Config: ${CPU} cores ($SELECTED_CPU), ${MEMORY} RAM, ${NET} network..."

# Start QEMU with built-in VNC server listening on port 5901
$QEMU_BIN $DEFAULT_MACHINE \
    -cpu "$SELECTED_CPU" \
    -m "$MEMORY" \
    -smp "$CPU" \
    -net nic -net "$NET" \
    -drive file=/workspace/disk.qcow2,format=qcow2 \
    $CDROM_ARG \
    -vnc :1 &

# Start noVNC to bridge the QEMU VNC server to the web browser on port 8080
/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 8080
