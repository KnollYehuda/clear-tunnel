# Use a full Python image instead of slim
FROM python:3.10

# Set working directory in container
WORKDIR /app

# Install dependencies (including Qt5 for full support)
RUN apt-get update && apt-get install -y \
    libx11-6 \
    libxrender1 \
    libxext6 \
    libssl-dev \
    mesa-utils \
    libglib2.0-0 \
    libxcb-xinerama0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render0 \
    libxcb-shape0 \
    libxcb-xfixes0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libfreetype6 \
    libfontconfig1 \
    dbus \
    dbus-x11 \
    meson \
    python3-dev \
    libglib2.0-dev \
    pkg-config \
    libdbus-1-dev \
    build-essential \
    qt5-qmake qtbase5-dev qtchooser qtbase5-dev-tools \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    gnupg \
    firefox-esr \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --no-cache-dir PyQt5 pyyaml dbus-python

ENV DEBIAN_FRONTEND="noninteractive"
ENV DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/dbus-0N0C59Q6t9,guid=272e3db39affee7fb17e5bdc67a8d981
RUN echo "Adding OpenVPN 3 repository and GPG key..."
RUN curl -fsSL https://packages.openvpn.net/packages-repo.gpg | tee /etc/apt/trusted.gpg.d/openvpn.asc
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/openvpn.asc] https://packages.openvpn.net/openvpn3/debian bookworm main" | tee /etc/apt/sources.list.d/openvpn-packages.list
RUN echo "Updating apt and installing OpenVPN 3..."
RUN apt update && apt install -y openvpn3


# Copy application files and the clear_tunnel.sh script
COPY . /app

# Make the clear_tunnel.sh script executable
RUN chmod +x /app/clear_tunnel.sh

# Set the entry point to run the bash script
ENTRYPOINT ["/app/clear_tunnel.sh"]
