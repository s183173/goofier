FROM quay.io/fedora/fedora:40

RUN dnf install -y \
    @kde-desktop \
    tigervnc-server \
    novnc \
    python3-websockify \
    dbus-x11 \
    sudo \
    git \
    && dnf clean all

RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode && \
    chmod 0440 /etc/sudoers.d/vscode

USER vscode

RUN mkdir -p /home/vscode/.vnc && \
    echo "password" | vncpasswd -f > /home/vscode/.vnc/passwd && \
    chmod 600 /home/vscode/.vnc/passwd

# Launch KDE Plasma when VNC starts
RUN echo '#!/bin/sh' > /home/vscode/.vnc/xstartup && \
    echo 'unset SESSION_MANAGER' >> /home/vscode/.vnc/xstartup && \
    echo 'unset DBUS_SESSION_BUS_ADDRESS' >> /home/vscode/.vnc/xstartup && \
    echo 'exec startplasma-x11' >> /home/vscode/.vnc/xstartup && \
    chmod +x /home/vscode/.vnc/xstartup

# Start VNC and noVNC
RUN echo '#!/bin/bash' > /home/vscode/start-vnc.sh && \
    echo 'vncserver :1 -geometry 1920x1080 -depth 24 -localhost no' >> /home/vscode/start-vnc.sh && \
    echo 'websockify --web /usr/share/novnc/ 6080 localhost:5901' >> /home/vscode/start-vnc.sh && \
    chmod +x /home/vscode/start-vnc.sh

EXPOSE 6080
USER vscode
