# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/GHOST/HARDWARE.NIX - Hardware Configuration for Ghost Laptop
# ═══════════════════════════════════════════════════════════════════════════════
#
# Hardware-specific settings for Ghost laptop (Lenovo ThinkPad P1 Gen 4).
# Uses: ext4 filesystem + LVM + LUKS encryption
#
# IMPORTANT: Update UUIDs after installation with: lsblk -f
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # BOOT MODULES - For LUKS, LVM, and laptop hardware
  # ═══════════════════════════════════════════════════════════════════════════
  boot.initrd.availableKernelModules = [
    "xhci_pci"        # USB 3.0
    "thunderbolt"     # Thunderbolt support
    "vmd"             # Intel Volume Management Device
    "nvme"            # NVMe SSD
    "usbhid"          # USB input devices
    "usb_storage"     # USB storage
    "sd_mod"          # SD card reader
    "dm_mod"          # Device mapper (for LVM/LUKS)
    "dm-raid"         # RAID support via device mapper
    "cryptd"          # Crypto acceleration
    "aesni_intel"     # Intel AES-NI acceleration
  ];

  boot.initrd.kernelModules = [
    "dm-snapshot"     # LVM snapshots
  ];

  boot.kernelModules = [
    "kvm-intel"       # Intel virtualization
    "btintel"         # Bluetooth
  ];

  boot.extraModulePackages = [ ];

  # ═══════════════════════════════════════════════════════════════════════════
  # LUKS ENCRYPTION
  # ═══════════════════════════════════════════════════════════════════════════
  # LUKS container on the physical partition
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/LUKS-PARTITION-UUID";  # Replace with actual LUKS UUID
    allowDiscards = true;      # Enable TRIM for SSD (security vs performance trade-off)
    bypassWorkqueues = true;   # Reduce latency on SSDs
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # LVM CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  # LVM volumes inside the decrypted LUKS container
  # Adjust volume group and logical volume names to match your setup

  # ═══════════════════════════════════════════════════════════════════════════
  # FILESYSTEMS - ext4 on LVM
  # ═══════════════════════════════════════════════════════════════════════════
  # Root filesystem on LVM logical volume
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ROOT-UUID";  # ext4 root LV UUID
    fsType = "ext4";
    options = [ "noatime" "discard" ];  # SSD optimizations
  };

  # Boot partition (unencrypted EFI)
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BOOT-UUID";  # EFI partition UUID
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" "uid=0" "gid=0" ];
  };

  # Home directory on separate LVM logical volume (optional)
  # fileSystems."/home" = {
  #   device = "/dev/disk/by-uuid/HOME-UUID";  # ext4 home LV UUID
  #   fsType = "ext4";
  #   options = [ "noatime" "discard" ];
  # };

  # ═══════════════════════════════════════════════════════════════════════════
  # SWAP - Encrypted swap on LVM (or swapfile)
  # ═══════════════════════════════════════════════════════════════════════════
  # Option 1: Dedicated swap LV
  # swapDevices = [
  #   { device = "/dev/disk/by-uuid/SWAP-UUID"; }  # swap LV UUID
  # ];

  # Option 2: Swapfile (create after boot)
  # swapDevices = [
  #   {
  #     device = "/var/swapfile";
  #     size = 16 * 1024;  # 16GB in MB
  #   }
  # ];

  # ═══════════════════════════════════════════════════════════════════════════
  # HARDWARE SETTINGS
  # ═══════════════════════════════════════════════════════════════════════════
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Intel CPU with microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Power management for laptop
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  powerManagement.enable = true;

  # Enable redistributable firmware (Wi-Fi, GPU, etc.)
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Graphics - Intel integrated + optional NVIDIA
  services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];  # Intel
  # For hybrid graphics: [ "nvidia" "intel" ]

  # ═══════════════════════════════════════════════════════════════════════════
  # VM TESTING NOTES
  # ═══════════════════════════════════════════════════════════════════════════
  # When testing in VM, temporarily comment out the LUKS section and
  # update filesystem UUIDs to match the VM's ext4 partitions.
  # See README.md for VM testing workflow.
}
