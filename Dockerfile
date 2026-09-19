# Use the official Fedora base image
FROM quay.io/fedora/fedora:40

# Install KDE Plasma, VNC server, and other necessary tools
# 'sudo' is crucial for granting privileges
RUN dnf install -y \
    @kde-desktop \
    tigervnc-server \
    novnc \
    supervisor \
    sudo \
    git \
    && dnf clean all

# Create a non-root user 'vscode' (Codespaces default)
RUN useradd -m -s /bin/bash vscode

# Give the 'vscode' user passwordless sudo access
# This is the key to having sudo in your Codespace
RUN echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode

# Set up the VNC server configuration for the 'vscode' user
USER vscode
RUN mkdir -p /home/vscode/.vnc
# Set a VNC password (you can change 'password' to something else)
RUN echo "password" | vncpasswd -f > /home/vscode/.vnc/passwd
RUN chmod 600 /home/vscode/.vnc/passwd

# Create a startup script for the VNC server
# This script starts the VNC server and the noVNC proxy
RUN echo '#!/bin/bash' > /home/vscode/start-vnc.sh && \
    echo 'vncserver :1 -geometry 1920x1080 -depth 24 -localhost no' >> /home/vscode/start-vnc.sh && \
    echo 'websockify --web /usr/share/novnc/ 6080 localhost:5901' >> /home/vscode/start-vnc.sh && \
    chmod +x /home/vscode/start-vnc.sh

# Expose the noVNC port (6080) so you can access it from your browser
EXPOSE 6080

# Set the default user
USER vscode
