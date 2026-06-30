# ═══════════════════════════════════════════════════════════════════════════════
# HOME/COMMON/DEFAULT.NIX - Common Home Manager Settings
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # HOME CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  home = {
    # Allow unfree packages
    sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
    
    # Enable home-manager
    enableNixpkgsReleaseCheck = false;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # XDG DIRECTORIES
  # ═══════════════════════════════════════════════════════════════════════════
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # COMMON PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # Archives
    zip
    unzip
    p7zip
    
    # Files
    file
    which
    tree
    
    # Network
    curl
    wget
    bind
    
    # Text
    jq
    yq
  ];
}
