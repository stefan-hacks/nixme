# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/DEBIAN-VM/DEFAULT.NIX - Debian VM Configuration
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  imports = [ ./hardware.nix ];
  
  networking.hostName = "debian-vm";
  system.stateVersion = "26.05";
  
  boot.loader.grub.device = "/dev/vda";
  
  # Development VM - lighter desktop
  # Note: services.xserver.desktopManager.gnome renamed to services.desktopManager.gnome in NixOS 26.05
  services.desktopManager.gnome.enable = lib.mkForce false;
  services.desktopManager.xfce.enable = true;
  services.displayManager.defaultSession = "xfce";
  
  environment.systemPackages = with pkgs; [
    xfce.thunar
    xfce.xfce4-terminal
    xfce.xfce4-panel
    xfce.xfce4-session
  ];
}
