# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/HOME/DEFAULT.NIX - Home Manager Modules
# ═══════════════════════════════════════════════════════════════════════════════
#
# Aggregates all Home Manager configurations.
#
# MODULES:
# ────────
# • shell.nix       - Shell aliases and functions
# • git.nix         - Git configuration with delta
# • terminal.nix    - Kitty + Zellij terminal setup
# • development.nix - Development tools and languages
# • desktop.nix     - User desktop apps and dconf
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, vars, ... }: {
  imports = [
    ./shell.nix
    ./git.nix
    ./terminal.nix
    ./development.nix
    ./desktop.nix
  ];
  
  # Base Home Manager configuration
  home = {
    username = vars.username;
    homeDirectory = vars.homeDirectory;
    stateVersion = "26.05";
  };
  
  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
