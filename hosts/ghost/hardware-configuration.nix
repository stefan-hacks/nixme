# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/GHOST/HARDWARE-CONFIGURATION.NIX - Hardware Configuration Placeholder
# ═══════════════════════════════════════════════════════════════════════════════
#
# ⚠️  IMPORTANT: This file MUST be replaced with your actual hardware configuration!
#
# To set up this file, run ONE of these commands on your Ghost laptop:
#
# Option A: Create symlink (recommended)
#   ln -sf /etc/nixos/hardware-configuration.nix ~/.config/nixme/hosts/ghost/hardware-configuration.nix
#
# Option B: Copy the file
#   cp /etc/nixos/hardware-configuration.nix ~/.config/nixme/hosts/ghost/hardware-configuration.nix
#
# The actual hardware-configuration.nix should contain:
#   - boot.initrd.availableKernelModules
#   - boot.kernelModules
#   - fileSystems."/"
#   - fileSystems."/boot"
#   - swapDevices (if any)
#   - nixpkgs.hostPlatform
#   - hardware.enableRedistributableFirmware
#   - boot.initrd.luks.devices (if using LUKS encryption)
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # PLACEHOLDER VALUES - Replace with your actual configuration!
  # These will cause the build to fail with a helpful message

  boot.initrd.availableKernelModules = [
    # TODO: Add your kernel modules from /etc/nixos/hardware-configuration.nix
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = lib.mkDefault {
    device = lib.mkDefault "/dev/disk/by-uuid/REPLACE-ME";
    fsType = lib.mkDefault "ext4";
  };

  fileSystems."/boot" = lib.mkDefault {
    device = lib.mkDefault "/dev/disk/by-uuid/REPLACE-ME";
    fsType = lib.mkDefault "vfat";
  };

  swapDevices = lib.mkDefault [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
