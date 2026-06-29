#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# INSTALL-GHOST.SH - Automated Ghost Laptop Installation Script
# ═══════════════════════════════════════════════════════════════════════════════
#
# This script automates the installation of NixOS on the Ghost laptop using disko.
# It handles disk partitioning, formatting, LUKS encryption, and system installation.
#
# REQUIREMENTS:
# ──────────────
# • Boot from NixOS minimal ISO (latest unstable)
# • Internet connection (Wi-Fi or Ethernet)
# • Git clone of the nixme repository
#
# USAGE:
# ──────
#   1. Boot from NixOS minimal ISO
#   2. Connect to internet: `sudo systemctl start wpa_supplicant` then `nmtui`
#   3. Clone repo: `git clone https://github.com/stefan-hacks/nixme`
#   4. Run: `sudo bash nixme/hosts/ghost/install-ghost.sh`
#   5. Reboot when complete
#
# WHAT THIS SCRIPT DOES:
# ──────────────────────
#   1. Prompts for disk device (default: /dev/nvme0n1)
#   2. Warns about data destruction
#   3. Runs disko to partition and format the disk
#   4. Generates hardware configuration
#   5. Installs NixOS with your flake
#   6. Sets root password
#   7. Prompts to reboot
#
# ═══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

# ═══════════════════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
FLAKE_NAME="ghost"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ═══════════════════════════════════════════════════════════════════════════
# HELPER FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_banner() {
    echo -e "${BLUE}"
    cat << 'EOF'
 ╔═══════════════════════════════════════════════════════════════════════╗
 ║                                                                       ║
 ║   Ghost Laptop - NixOS Installation with Disko                      ║
 ║                                                                       ║
 ║   LUKS Encryption + BTRFS Subvolumes + Full GNOME Desktop             ║
 ║                                                                       ║
 ╚═══════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

confirm() {
    read -r -p "$1 [y/N] " response
    [[ "$response" =~ ^[Yy]$ ]]
}

# ═══════════════════════════════════════════════════════════════════════════
# PRE-INSTALLATION CHECKS
# ═══════════════════════════════════════════════════════════════════════════
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if running as root
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
    
    # Check if we're on a NixOS live ISO
    if [[ ! -f /etc/nixos-release ]]; then
        log_error "This script must be run on a NixOS live ISO"
        exit 1
    fi
    
    # Check internet connectivity
    if ! ping -c 1 nixos.org &> /dev/null; then
        log_warn "No internet connection detected"
        log_info "Please connect to Wi-Fi using: nmtui"
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# ═══════════════════════════════════════════════════════════════════════════
# DISK SELECTION
# ═══════════════════════════════════════════════════════════════════════════
select_disk() {
    log_info "Available disks:"
    lsblk -dpno NAME,SIZE,MODEL | grep -E "disk|nvme"
    
    echo ""
    read -r -p "Enter disk to install on [default: /dev/nvme0n1]: " disk
    DISK_DEVICE="${disk:-/dev/nvme0n1}"
    
    # Verify disk exists
    if [[ ! -b "$DISK_DEVICE" ]]; then
        log_error "Disk $DISK_DEVICE does not exist"
        exit 1
    fi
    
    log_warn "WARNING: This will ERASE ALL DATA on $DISK_DEVICE"
    if ! confirm "Are you sure you want to continue?"; then
        log_info "Installation cancelled"
        exit 0
    fi
    
    log_info "Selected disk: $DISK_DEVICE"
}

# ═══════════════════════════════════════════════════════════════════════════
# UPDATE DISKO CONFIG
# ═══════════════════════════════════════════════════════════════════════════
update_disko_config() {
    log_info "Updating disko configuration for $DISK_DEVICE..."
    
    # Update the device in disko.nix
    sed -i "s|device = \"/dev/nvme0n1\";|device = \"$DISK_DEVICE\";|" "${SCRIPT_DIR}/disko.nix"
    
    log_success "Disko configuration updated"
}

# ═══════════════════════════════════════════════════════════════════════════
# PARTITION AND FORMAT WITH DISKO
# ═══════════════════════════════════════════════════════════════════════════
run_disko() {
    log_info "Partitioning and formatting disk with disko..."
    log_info "This may take a few minutes..."
    
    # Install disko and run it
    nix run github:nix-community/disko -- --mode disko "${SCRIPT_DIR}/disko.nix"
    
    log_success "Disk partitioning complete"
}

# ═══════════════════════════════════════════════════════════════════════════
# GENERATE HARDWARE CONFIG
# ═══════════════════════════════════════════════════════════════════════════
generate_hardware_config() {
    log_info "Generating hardware configuration..."
    
    # Mount the new root filesystem temporarily
    mkdir -p /mnt
    mount /dev/mapper/cryptroot /mnt || mount /dev/pool/root /mnt 2>/dev/null || true
    
    # Generate hardware config
    nixos-generate-config --root /mnt
    
    # Copy the generated hardware config
    cp /mnt/etc/nixos/hardware-configuration.nix "${SCRIPT_DIR}/hardware-generated.nix"
    
    log_success "Hardware configuration generated"
    log_info "Review and merge changes into hardware.nix if needed"
}

# ═══════════════════════════════════════════════════════════════════════════
# INSTALL NIXOS
# ═══════════════════════════════════════════════════════════════════════════
install_nixos() {
    log_info "Installing NixOS with flake .#${FLAKE_NAME}..."
    log_info "This will take 15-60 minutes depending on internet speed..."
    
    # Ensure mountpoints are ready
    mkdir -p /mnt/boot
    mount "${DISK_DEVICE}p1" /mnt/boot 2>/dev/null || mount "${DISK_DEVICE}1" /mnt/boot 2>/dev/null || true
    
    # Install NixOS
    nixos-install --flake "${REPO_DIR}#${FLAKE_NAME}" --no-root-passwd
    
    log_success "NixOS installation complete"
}

# ═══════════════════════════════════════════════════════════════════════════
# POST-INSTALLATION SETUP
# ═══════════════════════════════════════════════════════════════════════════
post_install() {
    log_info "Running post-installation setup..."
    
    # Set root password
    log_info "Setting root password..."
    echo "root:CHANGEME" | chpasswd -R /mnt
    log_warn "Root password set to 'CHANGEME' - CHANGE IT ON FIRST LOGIN!"
    
    # Ensure proper permissions on home directory
    mkdir -p /mnt/home/stefan-hacks
    chown 1000:1000 /mnt/home/stefan-hacks 2>/dev/null || true
    
    log_success "Post-installation complete"
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════
main() {
    print_banner
    
    # Step 1: Pre-flight checks
    check_prerequisites
    
    # Step 2: Select disk
    select_disk
    
    # Step 3: Update disko config
    update_disko_config
    
    # Step 4: Run disko
    run_disko
    
    # Step 5: Generate hardware config
    generate_hardware_config
    
    # Step 6: Install NixOS
    install_nixos
    
    # Step 7: Post-installation
    post_install
    
    # Done
    echo ""
    log_success "Installation complete!"
    echo ""
    echo -e "${GREEN}Next steps:${NC}"
    echo "  1. Reboot: sudo reboot"
    echo "  2. Login as root with password: CHANGEME"
    echo "  3. Change root password: passwd"
    echo "  4. Login as stefan-hacks"
    echo "  5. Enjoy your fully configured Ghost laptop!"
    echo ""
    
    if confirm "Reboot now?"; then
        reboot
    fi
}

# Run main function
main "$@"