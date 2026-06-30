# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/GHOST/HARDWARE.NIX - Hardware Configuration for Ghost Laptop
# ═══════════════════════════════════════════════════════════════════════════════
#
# INSTRUCTIONS:
# 1. Copy your working /etc/nixos/hardware-configuration.nix to this file
# 2. Keep the laptop-specific settings at the bottom
# 3. Test with: ./scripts/test-build.sh check
# ═══════════════════════════════════════════════════════════════════════════════

{ config, lib, pkgs, modulesPath, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # STEP 1: PASTE YOUR /etc/nixos/hardware-configuration.nix BELOW
  # ═══════════════════════════════════════════════════════════════════════════
  # Run: cat /etc/nixos/hardware-configuration.nix
  # Copy EVERYTHING between the outermost { and }
  #
  # REQUIRED: boot.initrd.availableKernelModules
  # REQUIRED: boot.kernelModules
  # REQUIRED: fileSystems."/"
  # REQUIRED: fileSystems."/boot"
  # REQUIRED: nixpkgs.hostPlatform
  # REQUIRED: hardware.enableRedistributableFirmware
  # ═══════════════════════════════════════════════════════════════════════════
  
  # === PASTE hardware-configuration.nix CONTENT BELOW THIS LINE ===
  # (Replace this entire comment block with your actual config)
  
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  
  # Example structure - REPLACE with your actual config from /etc/nixos/:
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usbhid" "usb_storage" "sd_mod" "dm_mod" "cryptd" "aesni_intel" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  
  # REPLACE with your actual UUIDs from /etc/nixos/hardware-configuration.nix
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-ROOT-UUID";
    fsType = "ext4";
    options = [ "noatime" "discard" ];
  };
  
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-BOOT-UUID";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };
  
  # Add your swap configuration here if you have it
  # swapDevices = [ { device = "/dev/disk/by-uuid/UUID"; } ];
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  
  # === END OF hardware-configuration.nix CONTENT ===
  
  # ═══════════════════════════════════════════════════════════════════════════
  # STEP 2: KEEP THESE LAPTOP-SPECIFIC SETTINGS
  # ═══════════════════════════════════════════════════════════════════════════
  # Add these at the bottom of your hardware-configuration.nix content:
  
  # Intel CPU microcode updates (for security)
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  # Power management for laptop battery life
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  powerManagement.enable = true;
  
  # Graphics driver (Intel integrated)
  services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];
  
  # ═══════════════════════════════════════════════════════════════════════════
  # STEP 3: LUKS CONFIGURATION (if using encryption)
  # ═══════════════════════════════════════════════════════════════════════════
  # If your hardware-configuration.nix doesn't include LUKS, add it here:
  #
  # boot.initrd.luks.devices."cryptroot" = {
  #   device = "/dev/disk/by-uuid/LUKS-PARTITION-UUID";
  #   allowDiscards = true;      # Enable TRIM for SSD
  #   bypassWorkqueues = true;   # Reduce latency
  # };
}
