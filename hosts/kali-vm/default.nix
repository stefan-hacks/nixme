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
    # Note: burpsuite may be available as burpsuite-community or burpsuite-pro
    # Using standard burpsuite name for now
    burpsuite
    # zap is the correct package name (verified)
    zap
    sqlmap
    wfuzz
    gobuster
    dirb
    
    # Exploitation
    # Note: metasploit is the correct package name (verified)
    metasploit
    
    # Forensics
    # Note: sleuthkit provides command-line tools
    sleuthkit
    # Note: autopsy is the correct package name (verified)
    autopsy
    
    # Wireless
    # Note: wifite renamed to wifite2 in NixOS 26.05
    aircrack-ng
    wifite2
    # Note: reaverwps is correct (verified on search.nixos.org)
    reaverwps
    
    # Password
    # Note: john is correct (verified on search.nixos.org, already Jumbo version)
    john
    hashcat
    # Note: thc-hydra is correct for THC Hydra password cracker
    # (the 'hydra' package is the Nix CI system, not the password tool)
    thc-hydra
    
    # Recon
    # Note: theHarvester renamed to theharvester (lowercase) in NixOS 26.05
    theharvester
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
