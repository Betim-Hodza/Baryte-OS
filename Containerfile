# Start from Universal Blue's Bazzite image for gaming support
FROM ghcr.io/ublue-os/bazzite-deck:latest

# Copy custom files
COPY --chmod=755 build.sh /tmp/build.sh
COPY --chmod=755 files/ /

# Update system and install programming tools
RUN rpm-ostree install \
    # Development tools
    gcc \
    clang \
    cmake \
    git \
    python3-pip \
    nodejs \
    vim \
    code \
    # Build essentials
    make \
    autoconf \
    automake \
    # Gaming optimizations from Aurora
    gamemode \
    mangohud \
    goverlay \
    lutris \
    # Custom gaming tools
    discord \
    steam \
    heroic-games-launcher \
    # Clean up
    && rpm-ostree cleanup -m && \
    systemctl enable gamemoded

# Install VS Code extensions
RUN mkdir -p /usr/share/code/extensions && \
    code --install-extension ms-python.python \
    code --install-extension 1YiB.rust-bundle \
    code --install-extension rust-lang.rust-analyzer \
    code --install-extension dustypomerleau.rust-syntax \
    code --install-extension golang.go \
    code --install-extension ms-vscode.cpptools \
    code --install-exension Nuxtr.nuxt-vscode-extentions \
    code --install-extension Nuxtr.nuxtr-vscode \
    code --install-extension Vue.volar \
    code --install-extension bradlc.vscode-tailwindcss \
    code --install-extension KristopherJafeth.gojo-theme
     

# Setup gaming optimizations
RUN echo "STEAM_RUNTIME=1" >> /etc/environment && \
    echo "STEAM_RUNTIME_HEAVY=1" >> /etc/environment

# Configure system optimization
RUN echo "vm.swappiness=10" >> /etc/sysctl.d/99-sysctl.conf && \
    echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.d/99-sysctl.conf

LABEL com.github.containers.toolbox="true" \
      name="baryte-os" \
      description="Custom OS combining programming and gaming features" \
      vendor="Baryte OS" \
      version="1.0"

