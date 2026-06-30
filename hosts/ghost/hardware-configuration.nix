# ═══════════════════════════════════════════════════════════════════════════════
# HARDWARE-CONFIGURATION.NIX - Placeholder File
# ═══════════════════════════════════════════════════════════════════════════════
#
# ⚠️  IMPORTANT: Replace this file with your actual hardware configuration!
#
# This is a placeholder. You MUST replace it with your system's actual
# hardware-configuration.nix from /etc/nixos/.
#
# Instructions:
#   cp /etc/nixos/hardware-configuration.nix ~/.config/nixme/hosts/ghost/
#
# This file is gitignored and will NOT be committed to the repository.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # PLACEHOLDER: Replace with your actual configuration
  # These values will cause the build to fail with a helpful message

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
