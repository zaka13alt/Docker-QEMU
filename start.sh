#!/bin/bash

# Clean up old locks
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

# 1. Start virtual display frame buffer (Display :1)
Xvfb :1 -screen 0 1024x768x24 &
sleep 2

# 2. Export display variable
export DISPLAY=:1

# 3. Start a light Window Manager
openbox-session &
sleep 1

# 4. Start a terminal app inside the desktop
xterm -geometry 80x24+0+0 &

# 5. Start noVNC pointing to the VNC port (websockify bridges to Xvfb/VNC)
# Replit exposes web servers on port 8080
echo "Starting noVNC server on port 8080..."
usr/bin/novnc_server --listen 8080 --vnc localhost:5901
