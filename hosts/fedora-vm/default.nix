# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/FEDORA-VM/DEFAULT.NIX - Fedora VM Configuration
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  imports = [ ./hardware.nix ];
  
  networking.hostName = "fedora-vm";
  system.stateVersion = "26.05";
  
  boot.loader.grub.device = "/dev/vda";
  
  # Minimal VM - no desktop
  services.xserver.enable = lib.mkForce false;
  
  # Container-focused
  virtualisation.podman.enable = true;
  virtualisation.containers.enable = true;
  
  environment.systemPackages = with pkgs; [
    podman
    podman-compose
    buildah
    skopeo
  ];
}
