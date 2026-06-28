# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/CORE/NETWORKING.NIX - Network Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# Configures network connectivity, firewall, SSH, and related services.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, vars, const, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # HOSTNAME
  # ═══════════════════════════════════════════════════════════════════════════
  # Set from the host configuration
  networking.hostName = vars.hostname;

  # ═══════════════════════════════════════════════════════════════════════════
  # NETWORK MANAGER
  # ═══════════════════════════════════════════════════════════════════════════
  networking.networkmanager = {
    enable = true;
    
    # Enable WiFi power saving (for laptops)
    wifi.powersave = true;
    
    # DNS configuration - use systemd-resolved
    dns = "systemd-resolved";
    
    # Ensure DNS works by disabling automatic DNS
    # This prevents NetworkManager from overriding systemd-resolved
    connectionConfig = {
      "dns-priority" = "-100";
    };
  };

  # Use systemd-resolved for DNS - PROPERLY CONFIGURED
  services.resolved = {
    enable = true;
    fallbackDns = [ "8.8.8.8" "1.1.1.1" ];
    # Settings for systemd-resolved (using proper Nix attribute syntax)
    settings = {
      # DNS Configuration for proper name resolution
      DNSSEC = "yes";
      DNSOverTLS = "no";
      Cache = "yes";
      DNSStubListener = "yes";
    };
  };
  
  # Ensure /etc/resolv.conf points to systemd-resolved
  networking.resolvconf.enable = true;
  
  # Use systemd-resolved's DNS stub
  environment.etc."resolv.conf".source = "/run/systemd/resolve/stub-resolv.conf";

  # ═══════════════════════════════════════════════════════════════════════════
  # FIREWALL
  # ═══════════════════════════════════════════════════════════════════════════
  networking.firewall = {
    enable = true;
    
    # Allow specific ports
    allowedTCPPorts = [
      # SSH (standard and VM ports)
      22
      const.vm-ssh-ports.kali-vm or 2221
      const.vm-ssh-ports.debian-vm or 2222
      const.vm-ssh-ports.fedora-vm or 2223
      
      # Syncthing
      const.ports.syncthing or 8384
      
      # Development
      const.ports.http or 80
      const.ports.https or 443
    ];
    
    allowedUDPPorts = [
      # mDNS for local service discovery
      5353
      # DNS resolution (required for systemd-resolved)
      53
      # DHCP
      67
      68
    ];
    
    # Allow ping
    allowPing = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SSH CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  services.openssh = {
    enable = true;
    
    settings = {
      # Security hardening
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      
      # Additional security
      X11Forwarding = false;
      MaxAuthTries = 3;
      ClientAliveInterval = 60;
      ClientAliveCountMax = 3;
    };
    
    # Host keys (from const)
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # AVAHI - mDNS Service Discovery
  # ═══════════════════════════════════════════════════════════════════════════
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # NETWORK TOOLS
  # ═══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    networkmanager
    openssh
    rsync
    curl
    wget
  ];
}
