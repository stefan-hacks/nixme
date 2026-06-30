# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/CORE/NETWORKING.NIX - Network Configuration (Simplified)
# ═══════════════════════════════════════════════════════════════════════════════
#
# Configures network connectivity, firewall, SSH, and related services.
# Simplified for Ghost laptop daily driver use.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, vars, const, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # HOSTNAME
  # ═══════════════════════════════════════════════════════════════════════════
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
    
    connectionConfig = {
      "dns-priority" = "-100";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # DNS CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  services.resolved = {
    enable = true;
    # DNS fallback servers
    settings.Resolve.FallbackDNS = [ "8.8.8.8" "1.1.1.1" ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # FIREWALL - Daily Driver Configuration
  # ═══════════════════════════════════════════════════════════════════════════
  networking.firewall = {
    enable = true;
    
    # Standard daily driver ports (matching Debian ufw setup)
    # Note: VM ports (2221-2224) are NOT needed here - VMs connect via
    # VirtualBox port forwarding to localhost, and localhost traffic
    # bypasses the firewall entirely.
    allowedTCPPorts = [
      22                # SSH (with rate limiting configured below)
      80                # HTTP
      443               # HTTPS
    ];
    
    allowedUDPPorts = [
      # mDNS for local service discovery
      5353
      # DNS resolution
      53
      # DHCP
      67
      68
      # ═══════════════════════════════════════════════════════════════════════
      # GAMING / VOIP (Uncomment as needed)
      # ═══════════════════════════════════════════════════════════════════════
      # 3478              # STUN (WebRTC, gaming)
      # 3479              # STUN alternate
      # 19302             # Google STUN
      # 19303             # Google STUN alternate
    ];
    
    # Allow ping
    allowPing = true;
    
    # ═══════════════════════════════════════════════════════════════════════════
    # ADVANCED FIREWALL OPTIONS (Commented)
    # ═══════════════════════════════════════════════════════════════════════════
    # # Enable strict reverse path filtering
    # checkReversePath = true;
    #
    # # Custom iptables rules
    # extraCommands = ''
    #   iptables -A INPUT -p tcp --dport 22 -m recent --set --name ssh
    #   iptables -A INPUT -p tcp --dport 22 -m recent --update --seconds 60 --hitcount 4 --name ssh -j DROP
    # '';
    #
    # # Port ranges
    # allowedTCPPortRanges = [
    #   { from = 10000; to = 20000; }  # Development range
    # ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SSH CONFIGURATION (with rate limiting like Debian ufw LIMIT)
  # ═══════════════════════════════════════════════════════════════════════════
  services.openssh = {
    enable = true;
    
    settings = {
      # Security hardening
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      
      # Rate limiting (like Debian ufw LIMIT)
      MaxAuthTries = 3;
      
      # Connection keepalive (matching SSH config)
      ClientAliveInterval = 60;
      ClientAliveCountMax = 3;
      
      # Disable X11 forwarding for security
      X11Forwarding = false;
    };
    
    # Host keys
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    
    # ═══════════════════════════════════════════════════════════════════════════
    # SSH SERVER OPTIONS (Commented)
    # ═══════════════════════════════════════════════════════════════════════════
    # # Alternative port (security through obscurity)
    # ports = [ 2222 ];
    #
    # # Allow specific users only
    # settings.AllowUsers = [ "stefan-hacks" ];
    #
    # # Gateway ports (for port forwarding)
    # settings.GatewayPorts = "no";
    #
    # # TCP forwarding
    # settings.AllowTcpForwarding = "yes";
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
    # Network diagnostic tools
    inetutils         # telnet, ftp, etc.
    nmap              # Network scanner
    tcpdump           # Packet analyzer
    mtr               # Network diagnostic
    whois
    dnsutils          # dig, nslookup
  ];
  
  # ═══════════════════════════════════════════════════════════════════════════
  # WIREGUARD / VPN SUPPORT (Commented)
  # ═══════════════════════════════════════════════════════════════════════════
  # networking.wg-quick.interfaces.wg0 = {
  #   address = [ "10.0.0.2/24" ];
  #   dns = [ "10.0.0.1" ];
  #   privateKeyFile = "/etc/wireguard/private.key";
  #   peers = [
  #     {
  #       publicKey = "...";
  #       allowedIPs = [ "0.0.0.0/0" ];
  #       endpoint = "vpn.example.com:51820";
  #       persistentKeepalive = 25;
  #     }
  #   ];
  # };
  #
  # Or use NetworkManager for WireGuard:
  # networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
}
