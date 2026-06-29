# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/GHOST/HARDWARE.NIX - Hardware Configuration (Disko-compatible)
# ═══════════════════════════════════════════════════════════════════════════════
#
# This file contains hardware-specific settings for the Ghost laptop.
# For disko-based installations, filesystems are defined in disko.nix,
# so this file only contains boot modules, kernel settings, and hardware options.
#
# NOTE: When using disko, DO NOT define fileSystems here - disko handles that!
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # BOOT MODULES
  # ═══════════════════════════════════════════════════════════════════════════
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"  # Thunderbolt support
    "vmd"          # Intel Volume Management Device
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "dm_mod"       # Device mapper for LUKS
    "cryptd"       # Crypto acceleration
    "aesni_intel"  # Intel AES acceleration
  ];
  
  boot.initrd.kernelModules = [ 
    "dm-snapshot"  # For LVM snapshots
  ];
  
  boot.kernelModules = [ 
    "kvm-intel"  # Intel virtualization
    "btintel"    # Bluetooth
  ];
  
  boot.extraModulePackages = [ ];

  # ═══════════════════════════════════════════════════════════════════════════
  # LUKS ENCRYPTION - Handled by disko, but kernel params here
  # ═══════════════════════════════════════════════════════════════════════════
  # NOTE: boot.initrd.luks.devices is NOT needed when using disko
  # disko automatically sets up the LUKS devices and mounting
  # 
  # If you need to specify specific LUKS devices manually (rarely needed):
  # boot.initrd.luks.devices."cryptroot" = {
  #   device = "/dev/disk/by-uuid/xxxxxx";
  #   allowDiscards = true;
  #   bypassWorkqueues = true;
  # };

  # ═══════════════════════════════════════════════════════════════════════════
  # FILESYSTEMS - NOT DEFINED HERE (handled by disko)
  # ═══════════════════════════════════════════════════════════════════════════
  # When using disko, all filesystems are defined in disko.nix
  # Including them here would conflict with disko's configuration
  
  # ═══════════════════════════════════════════════════════════════════════════
  # SWAP - Handled by disko (as part of the LVM)
  # ═══════════════════════════════════════════════════════════════════════════
  # swapDevices is managed by disko configuration
  # swapDevices = [ ];

  # ═══════════════════════════════════════════════════════════════════════════
  # HARDWARE SETTINGS
  # ═══════════════════════════════════════════════════════════════════════════
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # CPU microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Power management
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  
  # Enable redistributable firmware (for Wi-Fi, GPU, etc.)
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  
  # Graphics - Intel + NVIDIA hybrid (if applicable)
  # services.xserver.videoDrivers = [ "nvidia" "intel" ];
  # Or for Intel only:
  # services.xserver.videoDrivers = [ "modesetting" ];
}