# ═══════════════════════════════════════════════════════════════════════════════
# PARTS/DEFAULT.NIX - Flake Parts Aggregation
# ═══════════════════════════════════════════════════════════════════════════════
#
# This file imports all flake-parts modules from the parts/ directory.
# Each part is self-contained and handles a specific aspect of the flake.
#
# PARTS OVERVIEW:
# ────────────────
# • args.nix          - Common arguments and settings for all modules
# • lib/              - Custom library functions (mkOpt, enable, etc.)
# • const.nix         - Constants (SSH keys, ports, IPs)
# • nixos/            - NixOS system configurations (hosts)
# • home-manager/     - Home Manager configurations
# • devshells.nix     - Development shells
# • formatter.nix     - Code formatters
#
# ═══════════════════════════════════════════════════════════════════════════════

{...}: {
  imports = [
    # Arguments and settings available to all parts
    ./args.nix

    # Custom library functions
    ./lib

    # Constants (keys, ports, IPs)
    ./const.nix

    # NixOS system configurations
    ./nixos

    # Home Manager configurations
    ./home-manager

    # Development shells
    ./devshells.nix

    # Formatters
    ./formatter.nix
  ];
}
