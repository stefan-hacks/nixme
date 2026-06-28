# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/DEFAULT.NIX - NixOS Modules Root
# ═══════════════════════════════════════════════════════════════════════════════
#
# Aggregates all NixOS system modules. Each module configures a specific
# aspect of the NixOS system.
#
# MODULE CATEGORIES:
# ────────────────
# • core/         - Essential system functionality (boot, networking, users)
# • desktop/      - Graphical environment (GNOME, display managers)
# • hardware/     - Hardware-specific configuration (keyboards, etc.)
# • programs/     - User applications and CLI tools
# • security/     - Security tools (1Password, VPN, firewall)
# • virtualization/ - VMs and containers (QEMU, Podman)
# • network-tools/ - Network diagnostics and monitoring
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  imports = [
    # Core system modules
    ./core
    
    # Desktop environment
    ./desktop
    
    # Hardware configuration
    ./hardware
    
    # User programs and CLI tools
    ./programs
    
    # Security tools
    ./security
    
    # Virtualization and containers
    ./virtualization
    
    # Network tools
    ./network-tools
  ];
}
