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
    cava
    gnome-music
    #kew
    #easyeffects
    
    # Image viewers/editors
    shotwell
    #gimp
    #inkscape
    
    # Recording
    #obs-studio
    
    # Media codecs (usually pulled in by players)
    ffmpeg
    ffmpegthumbnailer
    
    # Streamers
    streamlink
    jellyfin-desktop

    # Podcasts
    #gpodder
    
    # Spotify
    #spotify
  ];
}
