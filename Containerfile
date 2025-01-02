ARG FEDORA_MAJOR_VERSION=41

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}

# Copy custom files
COPY --chmod=755 build.sh /tmp/build.sh
COPY --chmod=755 files/ /

# Enable RPM Fusion and VSCode repositories
RUN rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-41.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-41.noarch.rpm && \
    rpm-ostree cleanup -m

# Add VSCode repo
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/yum.repos.d/packages.microsoft.gpg && \
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo

# Install NVIDIA drivers if needed (commented out by default)
RUN rpm-ostree install \
     akmod-nvidia \
     xorg-x11-drv-nvidia \
     xorg-x11-drv-nvidia-cuda && \
     rpm-ostree cleanup -m

# Install development tools
RUN rpm-ostree install \
    git \
    gcc \
    gcc-c++ \
    cargo \
    rust \
    python3-pip \
    nodejs \
    code \
    podman \
    podman-docker \
    buildah \
    make \
    cmake && \
    rpm-ostree cleanup -m

# Install gaming tools
RUN rpm-ostree install \
    steam \
    gamemode \
    mangohud && \
    rpm-ostree cleanup -m

# Install EmuDeck dependencies
RUN rpm-ostree install \
    flatpak && \
    rpm-ostree cleanup -m

# Add Flathub repository
RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Enable services
RUN systemctl enable podman.socket || true  && \
    systemctl enable gamemoded.service || true

# Setup environment
RUN echo "STEAM_RUNTIME=1" >> /etc/environment && \
    echo "STEAM_RUNTIME_HEAVY=1" >> /etc/environment

# Install Ghostty (assuming it's available via flatpak)
RUN flatpak install -y flathub com.mitchellh.ghostty || true

LABEL com.github.containers.toolbox="true" \
      name="baryte-os" \
      description="Custom OS with development and gaming features" \
      vendor="Baryte OS" \
      version="1.0"
