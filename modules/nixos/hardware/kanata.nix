# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/HARDWARE/KANATA.NIX - Keyboard Remapping via Kanata
# ═══════════════════════════════════════════════════════════════════════════════
#
# This module configures kanata with the keyhack-kanata configuration.
# The kanata.kbd file is stored locally in this repository under
# assets/kanata/kanata.kbd to ensure reproducible builds.
#
# Source repo: https://github.com/stefan-hacks/keyhack-kanata
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  # ═══════════════════════════════════════════════════════════════════════════
  # KANATA SERVICE CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  services.kanata = {
    # Enable the kanata service
    enable = true;

    # Define keyboard configurations
    keyboards.default = {
      # Auto-detect keyboards (empty list = all keyboards)
      devices = [];

      # Extra defcfg settings (NixOS module generates the defcfg block)
      extraDefCfg = ''
        process-unmapped-keys yes
        log-layer-changes no
      '';

      # Load the kanata.kbd configuration from local file
      # Path from modules/nixos/hardware/ to assets/kanata/ is ../../../assets/kanata/
      # NOTE: This file should NOT contain (defcfg ...) as NixOS generates it
      config = builtins.readFile ../../../assets/kanata/kanata.kbd;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # REQUIRED KERNEL MODULES AND PERMISSIONS
  # ═══════════════════════════════════════════════════════════════════════════
  # Note: hardware.uinput.enable is automatically set by services.kanata.enable
  
  # Add kanata user to input group for keyboard device access
  users.groups.input = {};

  # Ensure kanata can access input devices
  services.udev.extraRules = ''
    # Allow kanata to access input devices
    KERNEL=="uinput", MODE="0660", GROUP="input", TAG+="uaccess"
    KERNEL=="event*", SUBSYSTEM=="input", MODE="0660", GROUP="input", TAG+="uaccess"
  '';

  # ═══════════════════════════════════════════════════════════════════════════
  # PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  # Make kanata available in system packages for debugging
  environment.systemPackages = with pkgs; [
    kanata
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # DOCUMENTATION
  # ═══════════════════════════════════════════════════════════════════════════
  # Kanata configuration reference:
  # - Repo: https://github.com/stefan-hacks/keyhack-kanata
  # - Official docs: https://github.com/jtroo/kanata
  #
  # Current features in kanata.kbd:
  # - Home row mods (tap-hold for Super/Alt/Control/Meta)
  # - Layer toggles (L2 on left Windows, L3 on spacebar)
  # - Function keys with hold actions (media controls, volume, etc.)
  # - Symbol layer with shifted versions on hold
  # - Text editing layer (L3) with navigation and mouse wheel
  # - Window management layer (L2) with workspace switching
  #
  # Key layers:
  # - base (one): Home row mods + tap-hold symbols
  # - two (L2): Window/workspace management (hold left Windows)
  # - three (L3): Text editing + mouse wheel (hold spacebar)
  #
  # TO UPDATE CONFIGURATION:
  # 1. Edit assets/kanata/kanata.kbd
  # 2. Or pull from keyhack-kanata repo: 
  #    curl -o assets/kanata/kanata.kbd https://raw.githubusercontent.com/stefan-hacks/keyhack-kanata/main/kanata.kbd
  # 3. Rebuild: sudo nixos-rebuild switch --flake .#ghost
}
