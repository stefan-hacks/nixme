# ═══════════════════════════════════════════════════════════════════════════════
# PROFILES/COMMON/DEFAULT.NIX - Base System Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# Every machine imports this profile. Contains universal settings.
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # LOCALIZATION
  # ═══════════════════════════════════════════════════════════════════════════
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # NIX SETTINGS
  # ═══════════════════════════════════════════════════════════════════════════
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Garbage Collection
    gc = {
      automatic = true;
      dates = "03:00";
      options = "--delete-older-than 7d";
    };

    # Store Optimisation
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    extraOptions = ''
      auto-optimise-store = true
      min-free = 1073741824
      max-free = 4294967296
    '';
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SECURITY BASE
  # ═══════════════════════════════════════════════════════════════════════════
  security = {
    sudo.enable = true;
    sudo.wheelNeedsPassword = true;
  };

  # SSH (base configuration)
  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = lib.mkDefault true;
      PubkeyAuthentication = true;
      MaxAuthTries = 3;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # FIREWALL BASE
  # ═══════════════════════════════════════════════════════════════════════════
  networking.firewall = {
    enable = lib.mkDefault true;
    allowedTCPPorts = lib.mkDefault [ 22 ];
    allowedUDPPorts = lib.mkDefault [ ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # COMMON PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # Essentials
    vim
    wget
    curl
    git
    htop
    iotop
    ncdu
    tree
    unzip
    p7zip
    jq
    ripgrep
    fd
    bat
    eza
    fzf
    zoxide
    direnv
    nix-index
    nix-output-monitor

    # System
    lm_sensors
    pciutils
    usbutils
    lsof
    sysstat
    ethtool
    iperf3

    # Security
    gnupg
    age
    sops
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # PROGRAMS
  # ═══════════════════════════════════════════════════════════════════════════
  programs = {
    vim.defaultEditor = true;
    git.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # FIRMWARE
  # ═══════════════════════════════════════════════════════════════════════════
  hardware.enableRedistributableFirmware = true;
}
