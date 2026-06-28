# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/SECURITY/DEFAULT.NIX - Security Configuration
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  imports = [
    ./vpn.nix
  ];
  
  environment.systemPackages = with pkgs; [
    # Password manager
    _1password-gui
    _1password-cli
    
    # Security tools
    gnupg
    openssl
    age
    
    # Network security
    wireshark
    tcpdump
  ];
}
