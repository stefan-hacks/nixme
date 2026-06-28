# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/PROGRAMS/DEFAULT.NIX - User Programs
# ═══════════════════════════════════════════════════════════════════════════════
#
# Aggregates all user application and shell configurations.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  imports = [
    ./bash.nix
    ./cli-tools.nix
    ./media.nix
    ./productivity.nix
    ./communication.nix
    ./downloader.nix
    ./firefox.nix
  ];
  
  programs = {
    bash = { enable = true; completion.enable = true; };
    less.enable = true;
  };
  
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    LESS = "-R";
    # Note: LANG/LC_ALL are set by i18n module via defaultLocale
    # in modules/nixos/core/locale.nix (currently en_AU.UTF-8)
  };
}
