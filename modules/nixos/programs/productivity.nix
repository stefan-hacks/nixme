# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/PROGRAMS/PRODUCTIVITY.NIX - Office and Productivity
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    # Office suite
    libreoffice
    
    # Note taking
    joplin-desktop
    obsidian
    
    # PDF
    zathura
    
    # Diagrams
    drawio
    
    # Calculators
    speedcrunch
    
    # Time management
    gnome-calendar
    gnome-todo
  ];
}
