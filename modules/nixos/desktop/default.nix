# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/DESKTOP/DEFAULT.NIX - Desktop Environment
# ═══════════════════════════════════════════════════════════════════════════════
#
# Configures the graphical desktop environment (GNOME) and display manager.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  imports = [
    ./gnome.nix
  ];
}
