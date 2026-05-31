#!/bin/bash

# Clean up old X11 locks
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

# Start virtual framebuffer X-server (Display :1)
Xvfb :1 -screen 0 1024x768x24 &
export DISPLAY=:1

# Wait for Xvfb to fully initialize
sleep 2

# Start Fluxbox window manager
fluxbox &

# Start an initial terminal inside the desktop
xterm -geometry 80x24+10+10 &

# Start noVNC pointing to the local Xvfb VNC port
# Note: websockify will automatically translate VNC to web sockets
websockify --web=/nix/store/*-novnc-*/share/novnc 6080 localhost:5900
