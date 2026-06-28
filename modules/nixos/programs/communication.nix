# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/PROGRAMS/COMMUNICATION.NIX - Communication Tools
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    # Messaging
    discord
    telegram-desktop
    signal-desktop
    
    # Email
    thunderbird
    
    # Video conferencing
    zoom-us
    
    # IRC
    hexchat
    
    # Matrix
    element-desktop
  ];
}
