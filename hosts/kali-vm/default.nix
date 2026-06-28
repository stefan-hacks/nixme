# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/KALI-VM/DEFAULT.NIX - Kali Linux VM Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# Penetration testing VM for security work.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, inputs, vars, const, ... }:

{
  imports = [ ./hardware.nix ];
  
  # ═══════════════════════════════════════════════════════════════════════════
  # HOST METADATA
  # ═══════════════════════════════════════════════════════════════════════════
  networking.hostName = "kali-vm";
  system.stateVersion = "26.05";
  
  # ═══════════════════════════════════════════════════════════════════════════
  # BOOT CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.efiSupport = false;
  
  # ═══════════════════════════════════════════════════════════════════════════
  # SECURITY TOOLS
  # ═══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # Network
    nmap
    wireshark
    tcpdump
    netcat-gnu
    masscan
    
    # Web
    burpsuite
    zap
    sqlmap
    wfuzz
    gobuster
    dirb
    
    # Exploitation
    metasploit
    
    # Forensics
    sleuthkit
    autopsy
    
    # Wireless
    # Note: wifite renamed to wifite2 in NixOS 26.05
    aircrack-ng
    wifite2
    reaverwps
    
    # Password
    john
    hashcat
    hydra
    
    # Recon
    theHarvester
    recon-ng
    amass
    sublist3r
    
    # OSINT
    maltego
    
    # Utilities
    binwalk
    foremost
    steghide
  ];
  
  # ═══════════════════════════════════════════════════════════════════════════
  # SERVICES
  # ═══════════════════════════════════════════════════════════════════════════
  # Enable PostgreSQL for Metasploit
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "msf" ];
    ensureUsers = [
      {
        name = "msf";
        ensureDBOwnership = true;
      }
    ];
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # NETWORKING
  # ═══════════════════════════════════════════════════════════════════════════
  networking.firewall.allowedTCPPorts = [ 4444 8080 ];
}
