# Start from Universal Blue's Bazzite image for gaming support
FROM ghcr.io/ublue-os/bazzite-deck:latest

# Copy custom files
COPY --chmod=755 build.sh /tmp/build.sh
COPY --chmod=755 files/ /

# Enable RPM Fusion repositories
RUN rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable VSCode repository
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    printf "[vscode]\nname=vscode\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo
# Install packages in groups to better handle dependencies
RUN rpm-ostree install \
    # Development tools
    gcc \
    clang \
    cmake \
    git \
    python3-pip \
    nodejs \
    vim \
    make \
    autoconf \
    automake && \
    rpm-ostree cleanup -m

# Install VSCode separately
RUN rpm-ostree install \
    code && \
    rpm-ostree cleanup -m

# Install gaming tools
RUN rpm-ostree install \
    gamemode \
    mangohud \
    goverlay \
    steam && \
    rpm-ostree cleanup -m

# Install additional gaming tools from RPM Fusion
RUN rpm-ostree install \
    lutris \
    discord \
    heroic-games-launcher && \
    rpm-ostree cleanup -m

# Setup gaming optimizations
RUN echo "STEAM_RUNTIME=1" >> /etc/environment && \
    echo "STEAM_RUNTIME_HEAVY=1" >> /etc/environment && \
    systemctl enable gamemoded

LABEL com.github.containers.toolbox="true" \
      name="baryte-os" \
      description="Custom OS combining programming and gaming features" \
      vendor="Baryte OS" \
      version="1.0"