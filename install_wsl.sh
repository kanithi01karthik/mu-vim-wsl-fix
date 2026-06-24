#!/usr/bin/env bash

# =============================================================================
#                               INSTALL_WSL.SH
# =============================================================================
# A wrapper script specifically for Windows Subsystem for Linux (WSL2).
# Validates that WSL2 is active, reminds the user to run WezTerm on the Windows
# host side, and delegates the remaining installations to install.sh.
# =============================================================================

set -e

# --- Terminal Color Definitions ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if we are running inside WSL at all
if ! grep -q -i "microsoft" /proc/version; then
  echo -e "${RED}[!] ERROR: This script is intended to run inside WSL (Windows Subsystem for Linux) only.${NC}"
  echo -e "If you are on pure Linux or macOS, run ${GREEN}./install.sh${NC} instead."
  exit 1
fi

# Check for WSL1 vs WSL2
# WSL1 has "Microsoft" in /proc/sys/kernel/osrelease but lacks "microsoft-standard" (which WSL2 has).
OS_RELEASE=$(cat /proc/sys/kernel/osrelease)
if [[ "$OS_RELEASE" != *"microsoft-standard"* ]]; then
  echo -e "${RED}[!] WARNING: WSL1 (Windows Subsystem for Linux Version 1) detected!${NC}"
  echo -e "DAP (Debugger connections), file-watchers, and system performance are severely limited under WSL1."
  echo -e "It is highly recommended to upgrade to WSL2. Run the following command in Windows PowerShell:"
  echo -e "    ${YELLOW}wsl --set-version <DistroName> 2${NC}"
  echo -e "To check your distribution name, run: ${YELLOW}wsl -l -v${NC}"
  echo -e "------------------------------------------------------------\n"
  read -p "Do you want to proceed anyway with WSL1? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# Remind user about WezTerm running on Windows side
echo -e "${BLUE}[→] INFO: WezTerm should be installed on the Windows Host side, not inside WSL.${NC}"
echo -e "Running WezTerm inside WSL requires an X11/Wayland server on Windows which degrades performance."
echo -e "Ensure WezTerm is installed on your Windows host (e.g. via winget: ${GREEN}winget install wez.wezterm${NC})."
echo -e "Once installed, WezTerm will automatically integrate and let you launch into your WSL shell."
echo -e "------------------------------------------------------------\n"

# Run main install script
log_step() {
  echo -e "${BLUE}[→]${NC} $1"
}

log_step "Delegating setup to main Linux installer (install.sh)..."
chmod +x ./install.sh
./install.sh
