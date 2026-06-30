# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/NIXOS-VM/DEFAULT.NIX - Standalone VM Configuration for Testing
# ═══════════════════════════════════════════════════════════════════════════════
#
# This is a MINIMAL standalone configuration for testing NixOS in a VM.
# It does NOT import the main modules/nixos to avoid conflicts with
# Ghost-specific settings.
#
# After installing NixOS in the VM:
# 1. Generate hardware config: sudo nixos-generate-config --show-hardware-config
# 2. Copy the fileSystems and boot.initrd values to hardware.nix below
# 3. Test: sudo nixos-rebuild switch --flake /path/to/nixme#nixos-vm
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  # Import VM-specific hardware configuration
  imports = [
    ./hardware.nix
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # BOOT CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  # Using GRUB for better VM compatibility (both BIOS and EFI)
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = false;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # Disable systemd-boot (we're using GRUB)
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  # ═══════════════════════════════════════════════════════════════════════════
  # HOSTNAME
  # ═══════════════════════════════════════════════════════════════════════════
  networking.hostName = "nixos-vm";

  # ═══════════════════════════════════════════════════════════════════════════
  # NETWORKING
  # ═══════════════════════════════════════════════════════════════════════════
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;  # Common VM interface name

  # Minimal firewall for VM
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];  # SSH only

  # DNS
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
      PasswordAuthentication = true;  # Easier for VM testing
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # BASIC SYSTEM PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # Essentials
    vim
    git
    htop
    curl
    wget

    # System tools
    file
    tree
    which

    # VM utilities (optional)
    # virtiofsd
    # spice-vdagent
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # TEST USER
  # ═══════════════════════════════════════════════════════════════════════════
  users.users.test = {
    isNormalUser = true;
    description = "Test User";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "changeme";  # CHANGE THIS!
    openssh.authorizedKeys.keys = [
      # Add your SSH public key here for key-based auth
      # "ssh-ed25519 AAAAC3... your-key-name"
    ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SUDO
  # ═══════════════════════════════════════════════════════════════════════════
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;  # For easier testing (remove in production)
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # NIX SETTINGS
  # ═══════════════════════════════════════════════════════════════════════════
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
      auto-optimise-store = true
    '';
    settings = {
      trusted-users = [ "root" "@wheel" ];
    };
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
  # IMPORTANT: Keep this at 26.05
  system.stateVersion = "26.05";
}
