# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/PROGRAMS/DOWNLOADER.NIX - Download Tools
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    # Download managers
    wget
    curl
    aria2
    
    # Torrent
    transmission-gtk
    qbittorrent
    
    # YouTube/other download
    yt-dlp
    
    # File sync
    rsync
    syncthing
  ];
  
  services.syncthing = {
    enable = true;
    user = "stefan-hacks";
    dataDir = "/home/stefan-hacks/.local/share/syncthing";
    configDir = "/home/stefan-hacks/.config/syncthing";
    guiAddress = "127.0.0.1:8384";
  };
}
