# ═══════════════════════════════════════════════════════════════════════════════
# FLAKE.NIX - NixOS Configuration with flake-parts
# ═══════════════════════════════════════════════════════════════════════════════
#
# This is the entry point for the entire NixOS configuration using flake-parts
# for modular, composable flake structure.
#
# WHAT IS FLAKE-PARTS?
# ─────────────────────
# flake-parts is a framework for writing Nix flakes in a modular way.
# Instead of one large flake.nix, configuration is split across the parts/
# directory, each handling a specific concern (hosts, packages, devshells, etc.)
#
# BENEFITS:
# ──────────
# • Modularity: Each part is self-contained and reusable
# • Composability: Easy to share configurations between flakes
# • Maintainability: Smaller, focused files instead of one giant flake.nix
# • IDE Support: Better LSP support with debug = true
#
# STRUCTURE:
# ───────────
# • parts/          - Modular flake components
#   ├── default.nix  - Aggregates all parts
#   ├── hosts.nix    - NixOS system configurations
#   ├── home-manager.nix - Home Manager configurations
#   ├── lib/         - Custom library functions
#   └── const.nix    - Constants (keys, ports, IPs)
#
# • modules/nixos/  - NixOS system modules
# • modules/home/   - Home Manager modules
# • hosts/          - Per-host configurations
#
# ═══════════════════════════════════════════════════════════════════════════════

{
  description = "NixOS Configuration for stefan-hacks - Modern flake-parts architecture";

  # ═══════════════════════════════════════════════════════════════════════════
  # INPUTS - External Dependencies
  # ═══════════════════════════════════════════════════════════════════════════
  inputs = {
    # ─────────────────────────────────────────────────────────────────────────
    # NIXPKGS - The Core Package Repository
    # ─────────────────────────────────────────────────────────────────────────
    # Using nixos-26.05 stable for reproducible, well-tested packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    
    # Unstable channel for packages that need latest features
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ─────────────────────────────────────────────────────────────────────────
    # FLAKE-PARTS - Modular Flake Framework
    # ─────────────────────────────────────────────────────────────────────────
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # HOME-MANAGER - User Environment Management
    # ─────────────────────────────────────────────────────────────────────────
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # DISKO - Declarative Disk Partitioning
    # ─────────────────────────────────────────────────────────────────────────
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # SOPS-NIX - Secret Management
    # ─────────────────────────────────────────────────────────────────────────
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # NIXOS-HARDWARE - Hardware-specific configurations
    # ─────────────────────────────────────────────────────────────────────────
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # DEPLOY-RS - Remote Deployment
    # ─────────────────────────────────────────────────────────────────────────
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # IMPERMANENCE - Ephemeral root support
    # ─────────────────────────────────────────────────────────────────────────
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # ALEJANDRA - Nix Formatter
    # ─────────────────────────────────────────────────────────────────────────
    alejandra = {
      url = "github:kamadorueda/alejandra/4.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # OUTPUTS - What This Flake Produces
  # ═══════════════════════════════════════════════════════════════════════════
  # Using flake-parts to organize outputs modularly
  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      # Required for nixd LSP support
      debug = true;

      # Systems to build for
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      # Import all parts from the parts/ directory
      imports = [
        ./parts
      ];
    };
}
