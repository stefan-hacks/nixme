# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/NIXOS-VM/MINIMAL.NIX - Minimal VM Configuration for Limited Disk Space
# ═══════════════════════════════════════════════════════════════════════════════
#
# A MINIMAL configuration for VM testing that excludes heavy packages.
# Use this when disk space is limited (under 50GB).
#
# To use: sudo nixos-rebuild switch --flake .#nixos-vm-minimal
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # HOSTNAME
  # ═══════════════════════════════════════════════════════════════════════════
  networking.hostName = "nixos-vm-minimal";

  # ═══════════════════════════════════════════════════════════════════════════
  # BOOT
  # ═══════════════════════════════════════════════════════════════════════════
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = false;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  # ═══════════════════════════════════════════════════════════════════════════
  # NETWORKING
  # ═══════════════════════════════════════════════════════════════════════════
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  services.resolved = {
    enable = true;
    settings.Resolve.FallbackDNS = [ "8.8.8.8" "1.1.1.1" ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SSH
  # ═══════════════════════════════════════════════════════════════════════════
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # MINIMAL PACKAGES (no heavy apps like Discord, VirtualBox, VSCode)
  # ═══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # Essentials only
    vim
    git
    htop
    curl
    wget
    file
    tree
    which
    less
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # USER
  # ═══════════════════════════════════════════════════════════════════════════
  users.users.test = {
    isNormalUser = true;
    description = "Test User";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "changeme";
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # NIX
  # ═══════════════════════════════════════════════════════════════════════════
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
      auto-optimise-store = true
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 1d";
    };
    settings.trusted-users = [ "root" "@wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # LOCALE
  # ═══════════════════════════════════════════════════════════════════════════
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # ═══════════════════════════════════════════════════════════════════════════
  # STATE VERSION
  # ═══════════════════════════════════════════════════════════════════════════
  system.stateVersion = "26.05";
}
