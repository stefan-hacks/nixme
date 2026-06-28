# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/PROGRAMS/COMMUNICATION.NIX - Communication Tools
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    # Messaging
    discord
    whatsie
    
    # Email
    evolution
    
    # Video conferencing
    #zoom-us
    
    # IRC
    #hexchat
    
    # Matrix
    #element-desktop
  ];
}
