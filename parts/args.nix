# ═══════════════════════════════════════════════════════════════════════════════
# PARTS/ARGS.NIX - Common Arguments for All Modules
# ═══════════════════════════════════════════════════════════════════════════════
#
# This module defines common arguments that are passed to all flake-parts modules.
# These arguments are available throughout the flake via specialArgs and extraSpecialArgs.
#
# ═══════════════════════════════════════════════════════════════════════════════

{lib, ...}: {
  perSystem = {system, ...}: {
    _module.args = {
      # pkgs is automatically provided by flake-parts
      # Additional package sets can be added here
    };
  };

  flake = {
    # These arguments are passed to all NixOS and Home Manager modules
    # via specialArgs and extraSpecialArgs
  };
}
