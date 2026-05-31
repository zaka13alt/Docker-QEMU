FROM debian:bookworm-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    tigervnc-standalone-server \
    tigervnc-common \
    fluxbox \
    novnc \
    websockify \
    luakit \
    procps \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Configure VNC password
RUN mkdir -p ~/.vnc && \
    echo "novnc" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Expose noVNC port
EXPOSE 8080

# Start VNC server, desktop, and web proxy
CMD vncserver :1 -geometry 1024x768 -depth 24 -rfbauth ~/.vnc/passwd && \
    DISPLAY=:1 fluxbox & \
    websockify --web /usr/share/novnc/ 8080 localhost:5901
