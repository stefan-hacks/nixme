# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/GHOST/DEFAULT.NIX - Ghost Laptop Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# Lenovo ThinkPad P1 Gen 4 - Daily Driver
#
# Architecture: common + terminal + desktop + laptop
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  imports = [
    # Hardware (must copy from /etc/nixos/)
    ./hardware-configuration.nix
    
    # Profiles (layered architecture)
    ../../profiles/common        # Base: locale, nix, security, firewall
    ../../profiles/terminal      # CLI: bash, kitty, neovim, dev tools
    ../../profiles/desktop       # GUI: GNOME, audio, fonts
    ../../profiles/laptop        # Power: TLP, touchpad, firmware
    
    # User
    ../../users/stefan.nix
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # HOST METADATA
  # ═══════════════════════════════════════════════════════════════════════════
  networking.hostName = "ghost";
  system.stateVersion = "26.05";

  # ═══════════════════════════════════════════════════════════════════════════
  # BOOTLOADER
  # ═══════════════════════════════════════════════════════════════════════════
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    configurationLimit = 20;
    fontSize = 24;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  boot.loader.timeout = 5;

  # ═══════════════════════════════════════════════════════════════════════════
  # KERNEL
  # ═══════════════════════════════════════════════════════════════════════════
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "nohibernate"
    "elevator=none"
    "quiet"
    "splash"
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # HOST-SPECIFIC PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # ThinkPad specific
    linux-firmware
  ];
}
