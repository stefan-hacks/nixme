# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/NIXOS-VM/HARDWARE.NIX - VM Hardware Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# Generated from VM hardware-configuration.nix
# Copy values from: sudo nixos-generate-config --show-hardware-config
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # BOOT MODULES (VM-specific)
  # ═══════════════════════════════════════════════════════════════════════════
  # These are typical VM modules - adjust based on your hypervisor
  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # ═══════════════════════════════════════════════════════════════════════════
  # FILESYSTEMS (Update these with your VM's actual UUIDs)
  # ═══════════════════════════════════════════════════════════════════════════
  # After installing NixOS in the VM, get UUIDs with: lsblk -f
  # Then replace the placeholder UUIDs below

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/VM-ROOT-UUID";
    fsType = "ext4";  # VMs typically use ext4, change if using BTRFS
    # options = [ "subvol=@" "compress=zstd:1" ];  # For BTRFS
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/VM-BOOT-UUID";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SWAP
  # ═══════════════════════════════════════════════════════════════════════════
  # Uncomment and update if VM has swap
  # swapDevices = [
  #   { device = "/dev/disk/by-uuid/VM-SWAP-UUID"; }
  # ];

  # ═══════════════════════════════════════════════════════════════════════════
  # HARDWARE SETTINGS
  # ═══════════════════════════════════════════════════════════════════════════
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Enable redistributable firmware (Wi-Fi, etc. if passed through)
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Graphics - basic frame buffer for VM
  services.xserver.videoDrivers = [ "modesetting" "fbdev" ];

  # VM typically doesn't need power management
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
