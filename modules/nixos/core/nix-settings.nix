# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/CORE/NIX-SETTINGS.NIX - Nix Package Manager Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# Configures the Nix package manager itself - experimental features,
# garbage collection, binary caches, and flake support.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, inputs, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # NIX SETTINGS
  # ═══════════════════════════════════════════════════════════════════════════
  nix = {
    # Enable flakes and nix-command
    package = pkgs.nixVersions.stable;
    
    extraOptions = ''
      # Enable flakes and the new nix command
      experimental-features = nix-command flakes
      
      # Auto-optimise store by hard-linking identical files
      auto-optimise-store = true
      
      # Limit parallel builds to prevent system overload
      max-jobs = auto
      cores = 0
    '';

    # ═════════════════════════════════════════════════════════════════════════
    # GARBAGE COLLECTION
    # ═════════════════════════════════════════════════════════════════════════
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # ═════════════════════════════════════════════════════════════════════════
    # BINARY CACHES
    # ═════════════════════════════════════════════════════════════════════════
    settings = {
      # Trusted binary caches
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGpcvKgH44="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Q6Y7P+qdduC9VG2jyLqX4=7h5m="
      ];
      
      # Trusted users (can add binary caches)
      trusted-users = [ "root" "@wheel" ];
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # NIXPKGS CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "steam"
        "nvidia"
        "vscode"
      ];
    };
    
    overlays = [
      # Add custom overlays here
    ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SYSTEM PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    nix-output-monitor    # Better nix build output (nom)
    nixfmt                # Nix formatter
    direnv                # Environment switcher
    nix-direnv            # Better direnv integration with nix
  ];
}
