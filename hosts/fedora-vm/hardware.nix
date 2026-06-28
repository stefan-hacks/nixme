# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/FEDORA-VM/HARDWARE.NIX - Fedora VM Hardware
# ═══════════════════════════════════════════════════════════════════════════════

{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ ];
  
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  
  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };
  
  swapDevices = [ ];
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
