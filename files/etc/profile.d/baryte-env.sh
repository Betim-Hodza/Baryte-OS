#!/bin/bash
# Add Bun to path
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Add local bin to path
export PATH="$HOME/.local/bin:$PATH"

# Set development environment variables
export EDITOR=vim
