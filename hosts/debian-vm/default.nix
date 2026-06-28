# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/DEBIAN-VM/DEFAULT.NIX - Debian VM Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# Debian VM using standard GNOME desktop (same as ghost).
# Previously had XFCE for lighter resource usage, but now standardized
# on GNOME across all hosts for consistency.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  imports = [ ./hardware.nix ];
  
  networking.hostName = "debian-vm";
  system.stateVersion = "26.05";
  
  boot.loader.grub.device = "/dev/vda";
  
  # Note: Desktop environment is configured in modules/nixos/desktop/gnome.nix
  # which is imported by all hosts through modules/nixos/default.nix
  # This provides consistent GNOME experience across all hosts.
}
