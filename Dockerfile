FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV RESOLUTION=1024x768x24

RUN apt-get update && apt-get install -y --no-install-recommends \
    tigervnc-standalone-server \
    tigervnc-tools \
    fluxbox \
    novnc \
    websockify \
    firefox-esr \
    ca-certificates \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ~/.vnc && \
    echo "novnc" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

EXPOSE 8080

CMD vncserver $DISPLAY -geometry ${RESOLUTION%x*} -depth ${RESOLUTION##*x} -localhost no -rfbauth ~/.vnc/passwd && \
    /usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 8080
