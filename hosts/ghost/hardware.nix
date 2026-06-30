# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/GHOST/HARDWARE.NIX - Laptop-Specific Hardware Settings
# ═══════════════════════════════════════════════════════════════════════════════
#
# This file contains laptop-specific settings NOT in hardware-configuration.nix:
# - CPU microcode updates
# - Power management
# - Graphics drivers
# - Laptop sensors
#
# The actual hardware configuration (UUIDs, filesystems, kernel modules)
# should be in hardware-configuration.nix (symlinked or copied from /etc/nixos/)
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, lib, pkgs, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # CPU MICROCODE UPDATES
  # ═══════════════════════════════════════════════════════════════════════════
  # Intel CPU security updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # ═══════════════════════════════════════════════════════════════════════════
  # POWER MANAGEMENT
  # ═══════════════════════════════════════════════════════════════════════════
  # Laptop power saving
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # GRAPHICS
  # ═══════════════════════════════════════════════════════════════════════════
  # Intel integrated graphics (Ghost has Intel + optional NVIDIA)
  services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];
  # For hybrid mode: [ "nvidia" "intel" ]

  # ═══════════════════════════════════════════════════════════════════════════
  # LAPTOP SENSORS
  # ═══════════════════════════════════════════════════════════════════════════
  # Hardware monitoring
  hardware.sensor.iio.enable = true;
}
