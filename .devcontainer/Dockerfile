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

# Create systemd user service for VNC
RUN mkdir -p /home/vscode/.config/systemd/user && \
    echo '[Unit]' > /home/vscode/.config/systemd/user/vncserver@.service && \
    echo 'Description=Remote desktop service (VNC)' >> /home/vscode/.config/systemd/user/vncserver@.service && \
    echo 'After=syslog.target network.target' >> /home/vscode/.config/systemd/user/vncserver@.service && \
    echo '' >> /home/vscode/.config/systemd/user/vncserver@.service && \
    echo '[Service]' >> /home/vscode/.config/systemd/user/vncserver@.service && \
    echo 'Type=forking' >> /home/vscode/.config/systemd/user/vncserver@.service && \
    echo 'ExecStart=/usr/bin/vncserver %i -geometry 1920x1080 -depth 24 -localhost no' >> /home/vscode/.config/systemd/user/vncserver@.service && \
    echo 'ExecStop=/usr/bin/vncserver -kill %i' >> /home/vscode/.config/systemd/user/vncserver@.service && \
    echo '' >> /home/vscode/.config/systemd/user/vncserver@.service && \
    echo '[Install]' >> /home/vscode/.config/systemd/user/vncserver@.service && \
    echo 'WantedBy=default.target' >> /home/vscode/.config/systemd/user/vncserver@.service

EXPOSE 6080
USER vscode
