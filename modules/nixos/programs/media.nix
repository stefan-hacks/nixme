# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/PROGRAMS/MEDIA.NIX - Media Players and Tools
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    # Video players
    mpv
    vlc
    
    # Audio
    pavucontrol
    easyeffects
    
    # Image viewers/editors
    gimp
    inkscape
    
    # Recording
    obs-studio
    
    # Media codecs (usually pulled in by players)
    ffmpeg
    ffmpegthumbnailer
    
    # Streamers
    streamlink
    
    # Podcasts
    gpodder
    
    # Spotify
    spotify
  ];
}
