# ═══════════════════════════════════════════════════════════════════════════════
# PROFILES/SERVER/DEFAULT.NIX - Server Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# Server-specific settings. No GUI, just services and remote access.
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # NO GUI
  # ═══════════════════════════════════════════════════════════════════════════
  services.xserver.enable = lib.mkForce false;

  # ═══════════════════════════════════════════════════════════════════════════
  # SSH - Hardened
  # ═══════════════════════════════════════════════════════════════════════════
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      MaxAuthTries = 3;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
    };
    ports = [ 22 ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # FIREWALL
  # ═══════════════════════════════════════════════════════════════════════════
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # FAIL2BAN
  # ═══════════════════════════════════════════════════════════════════════════
  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "1h";
    findtime = "10m";
    extraJails = {
      sshd = ''''
        enabled = true
        port = 22
        filter = sshd
        logpath = /var/log/auth.log
        maxretry = 3
      ''';
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # COCKPIT - Web admin
  # ═══════════════════════════════════════════════════════════════════════════
  services.cockpit = {
    enable = lib.mkDefault true;
    openFirewall = true;
    port = 9090;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # CONTAINER ORCHESTRATION
  # ═══════════════════════════════════════════════════════════════════════════
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    docker = {
      enable = lib.mkDefault false;
      storageDriver = lib.mkDefault "overlay2";
    };

    oci-containers = {
      backend = "podman";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # MONITORING
  # ═══════════════════════════════════════════════════════════════════════════
  services.prometheus = {
    enable = lib.mkDefault false;
    port = 9090;
    exporters = {
      node = {
        enable = lib.mkDefault true;
        enabledCollectors = [ "systemd" ];
        port = 9100;
      };
    };
    scrapeConfigs = lib.mkDefault [
      {
        job_name = "node";
        static_configs = [{
          targets = [ "localhost:9100" ];
        }];
      }
    ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # WIREGUARD / TAILSCALE
  # ═══════════════════════════════════════════════════════════════════════════
  services.tailscale = {
    enable = lib.mkDefault false;
    useRoutingFeatures = lib.mkDefault "server";
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # AUTOMATIC UPGRADES
  # ═══════════════════════════════════════════════════════════════════════════
  system.autoUpgrade = {
    enable = lib.mkDefault true;
    flake = lib.mkDefault "github:stefan-hacks/nixme";
    flags = [ "--refresh" ];
    dates = "04:00";
    randomizedDelayMinutes = 60;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SERVER PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # Monitoring
    htop
    btop
    iotop
    ncdu
    smartmontools

    # Network
    tcpdump
    wireshark-cli
    nmap
    mtr

    # Security
    fail2ban
    openssl
    cfssl

    # Backup
    restic
    rclone

    # Containers
    podman
    podman-compose
    skopeo

    # Utils
    tmux
    screen
    ranger
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # NO SLEEP
  # ═══════════════════════════════════════════════════════════════════════════
  services.logind.lidSwitch = lib.mkForce "ignore";
  powerManagement.enable = false;
}
