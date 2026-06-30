# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/GHOST/HARDWARE.NIX - Hardware Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# This file contains hardware-specific settings for the Ghost laptop.
# Includes boot modules, kernel settings, hardware options, and filesystems.
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
  # FILESYSTEMS
  # ═══════════════════════════════════════════════════════════════════════════
  # Define your filesystems here. These were previously managed by disko.
  # Update UUIDs to match your actual disk configuration.
  #
  # To find UUIDs: lsblk -f
  #
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/CHANGE-ME";  # BTRFS root subvolume
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd:1" "noatime" "discard=async" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/CHANGE-ME";  # Same device as root
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd:1" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/CHANGE-ME";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd:1" "noatime" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/CHANGE-ME";
    fsType = "btrfs";
    options = [ "subvol=@persist" "compress=zstd:1" "noatime" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/CHANGE-ME";
    fsType = "btrfs";
    options = [ "subvol=@log" "compress=zstd:1" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CHANGE-ME-ESP";  # EFI partition
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # LUKS ENCRYPTION
  # ═══════════════════════════════════════════════════════════════════════════
  # If using LUKS encryption, configure it here:
  # boot.initrd.luks.devices."cryptroot" = {
  #   device = "/dev/disk/by-uuid/xxxxxx";
  #   allowDiscards = true;      # Enable TRIM for SSD
  #   bypassWorkqueues = true;     # Reduce latency
  # };

  # ═══════════════════════════════════════════════════════════════════════════
  # SWAP
  # ═══════════════════════════════════════════════════════════════════════════
  # Configure swap devices here
  # swapDevices = [ 
  #   { device = "/dev/disk/by-uuid/xxxxxx"; }  # swap partition
  # ];

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
