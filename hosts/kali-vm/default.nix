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
    # zap may be zaproxy in some versions
    zaproxy
    sqlmap
    wfuzz
    gobuster
    dirb
    
    # Exploitation
    # Note: metasploit package is now metasploit-framework
    metasploit-framework
    
    # Forensics
    # Note: sleuthkit provides command-line tools; autopsy-gui is the GUI package name
    sleuthkit
    # autopsy renamed to autopsy-gui in NixOS 26.05
    autopsy-gui
    
    # Wireless
    # Note: wifite renamed to wifite2 in NixOS 26.05
    aircrack-ng
    wifite2
    # Note: reaverwps renamed to reaver in NixOS 26.05
    reaver
    
    # Password
    # Note: john package is now john-jumbo (Jumbo patch version)
    john-jumbo
    hashcat
    # Note: hydra may be thc-hydra in some versions
    thc-hydra
    
    # Recon
    # Note: theHarvester renamed to theharvester (lowercase) in NixOS 26.05
    theharvester
    recon-ng
    amass
    # Note: sublist3r may need to be python3Packages.sublist3r or similar
    sublist3r
    
    # OSINT
    # Note: maltego is available as maltego package
    maltego
    
    # Utilities
    binwalk
    foremost
    # Note: steghide may not be available; steghide is the standard name
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
