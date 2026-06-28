# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/LIN-AI/HARDWARE.NIX - AI Workstation Hardware
# ═══════════════════════════════════════════════════════════════════════════════
#
# Hardware configuration for AI workstation with NVIDIA GPU.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];
  
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
  
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  
  # Filesystems (update with actual UUIDs)
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/YOUR-ROOT-UUID";
    fsType = "ext4";
  };
  
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/YOUR-BOOT-UUID";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };
  
  swapDevices = [ ];
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
